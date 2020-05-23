defmodule Edgybot.Meta do
  alias Edgybot.Repo
  alias Edgybot.Meta.{User, Server, Member, Channel}
  alias Nostrum.Api

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(snowflake) when is_integer(snowflake) do
    User
    |> Repo.get_by(snowflake: snowflake)
  end

  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  def get_server(snowflake) when is_integer(snowflake) do
    Server
    |> Repo.get_by(snowflake: snowflake)
  end

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end

  def get_channel(snowflake) when is_integer(snowflake) do
    Channel
    |> Repo.get_by(snowflake: snowflake)
  end

  def ensure_exists(opts) when is_list(opts) do
    result =
      opts
      |> Enum.map(fn {key, value} ->
        case key do
          :server_snowflake ->
            get_entity_local = &get_server/1
            get_entity_remote = Keyword.get(opts, :get_server_remote, &Api.get_guild/1)
            create_entity = &create_server/1
            {:ok, struct} = ensure_exists_entity(value, get_entity_local, get_entity_remote, create_entity)
            struct
          :channel_snowflake ->
            get_entity_local = &get_channel/1
            get_entity_remote = Keyword.get(opts, :get_channel_remote, &Api.get_channel/1)
            create_entity = &create_channel/1
            {:ok, struct} = ensure_exists_entity(value, get_entity_local, get_entity_remote, create_entity)
            struct
          _ -> :skip
        end
      end)
      |> Enum.filter(fn item -> item != :skip end)

    case Enum.count(result) do
      1 -> Enum.at(result, 0)
      _ -> result
    end
  end

  defp ensure_exists_entity(snowflake, get_entity_local, get_entity_remote, create_entity) when is_integer(snowflake) and is_function(get_entity_local) and is_function(get_entity_remote) and is_function(create_entity) do
    case get_entity_local.(snowflake) do
      nil ->
        entity_remote = get_entity_remote.(snowflake)
        case entity_remote do
          {:ok, entity} ->
            attrs = Map.from_struct(entity)
            case create_entity.(attrs) do
              {:ok, created_entity} -> {:ok, created_entity}
              {:error, changeset} -> raise "Unable to create entity with attrs #{inspect(attrs)} and error changeset #{inspect(changeset)}"
            end
          {:error, reason} -> raise "Unable to get entity from Discord with snowflake #{snowflake} because #{reason}"
        end
      entity_local -> {:ok, entity_local}
    end
  end
end

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

  def get_member(user_id, server_id) when is_integer(user_id) and is_integer(server_id) do
    Member
    |> Repo.get_by(user_id: user_id, server_id: server_id)
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
            get_entity_local = fn -> get_server(value) end
            get_entity_remote = Keyword.get(opts, :get_server_remote, fn -> Api.get_guild(value) end)
            create_entity = &create_server/1
            {:ok, struct} = ensure_exists_entity(get_entity_local, get_entity_remote, create_entity)
            struct
          :channel_snowflake ->
            get_entity_local = fn -> get_channel(value) end
            get_entity_remote = Keyword.get(opts, :get_channel_remote, fn -> Api.get_channel(value) end)
            create_entity = &create_channel/1
            {:ok, struct} = ensure_exists_entity(get_entity_local, get_entity_remote, create_entity)
            struct
          :user_snowflake ->
            get_entity_local = fn -> get_user(value) end
            get_entity_remote = Keyword.get(opts, :get_user_remote, fn -> Api.get_user(value) end)
            create_entity = &create_user/1
            {:ok, struct} = ensure_exists_entity(get_entity_local, get_entity_remote, create_entity)
            struct
          :member_ids ->
            user_id = elem(value, 0)
            server_id = elem(value, 1)
            get_entity_local = fn -> get_member(user_id, server_id) end
            get_entity_remote = Keyword.get(opts, :get_member_remote, fn -> Api.get_guild_member(server_id, user_id) end)
            create_entity = &create_member/1
            {:ok, struct} = ensure_exists_entity(get_entity_local, get_entity_remote, create_entity)
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

  defp ensure_exists_entity(get_entity_local, get_entity_remote, create_entity) when is_function(get_entity_local) and is_function(get_entity_remote) and is_function(create_entity) do
    case get_entity_local.() do
      nil ->
        entity_remote = get_entity_remote.()
        case entity_remote do
          {:ok, entity} ->
            attrs = Map.from_struct(entity)
            case create_entity.(attrs) do
              {:ok, created_entity} -> {:ok, created_entity}
              {:error, changeset} -> raise "Unable to create entity with attrs #{inspect(attrs)} and error changeset #{inspect(changeset)}"
            end
          {:error, reason} -> raise "Unable to get entity from Discord because #{reason}"
        end
      entity_local -> {:ok, entity_local}
    end
  end
end

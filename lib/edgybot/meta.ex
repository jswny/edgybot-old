defmodule Edgybot.Meta do
  alias Edgybot.Repo
  alias Edgybot.Meta.{User, Server, Member, Channel}
  alias Nostrum.Api

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
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

  def ensure_exists(opts) when is_list(opts) do
    opts
    |> Enum.map(fn {key, value} ->
      case key do
        :server_snowflake ->
          ensure_exists_entity(value, &get_server/1, &Api.get_guild/1)
        true ->
          raise "Unhandled option {#{key}, #{value}}"
      end
    end)
  end

  defp ensure_exists_entity(snowflake, get_entity_local, get_entity_remote) when is_integer(snowflake) and is_function(get_entity_local) and is_function(get_entity_remote) do
    case get_entity_local.(snowflake) do
      nil ->
        server = get_entity_remote.(snowflake)
        case server do
          {:ok, server} ->
            attrs = %{
              snowflake: snowflake,
              name: server.name,
              active: true
            }
            case create_server(attrs) do
              {:ok, struct} -> {:ok, struct}
              {:error, changeset} -> raise "Unable to create server with attrs #{attrs} and error changeset #{changeset}"
            end
          {:error, reason} -> raise "Unable to get server from Discord with snowflake #{snowflake} because #{reason}"
        end
      server -> {:ok, server}
    end
  end
end

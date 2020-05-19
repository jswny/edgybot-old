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
          ensure_exists_server(value)
        true ->
          raise "Unhandled option {#{key}, #{value}}"
      end
    end)
  end

  defp ensure_exists_server(snowflake) when is_integer(snowflake) do
    case get_server(snowflake) do
      nil ->
        server = Api.get_guild(snowflake)
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

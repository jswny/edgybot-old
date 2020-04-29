defmodule Edgybot.Meta do
  alias Edgybot.Repo
  alias Edgybot.Meta.Server
  alias Edgybot.Meta.Channel

  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end

  def create_channel(attrs \\ %{}) do
    %Channel{}
    |> Channel.changeset(attrs)
    |> Repo.insert()
  end
end

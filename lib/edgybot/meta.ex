defmodule Edgybot.Meta do
  alias Edgybot.Repo
  alias Edgybot.Meta.Server

  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
  end
end

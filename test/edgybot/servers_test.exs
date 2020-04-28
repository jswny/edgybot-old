defmodule Edgybot.ServersTest do
  use Edgybot.RepoCase

  alias Edgybot.Meta
  alias Edgybot.Meta.Server

  @valid_attrs %{
    discord_id: "123",
    name: "foo"
  }

  describe "servers" do
    test "create_server/1 with valid data creates a server" do
      assert {:ok, %Server{}} = Meta.create_server(@valid_attrs)
    end
  end
end

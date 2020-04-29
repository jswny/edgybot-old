defmodule Edgybot.ServersTest do
  use Edgybot.RepoCase

  alias Edgybot.Meta

  @valid_attrs %{
    discord_id: "123",
    name: "foo"
  }

  @invalid_attrs %{
    discord_id: "123",
  }

  describe "servers" do
    alias Edgybot.Meta.Server

    test "create_server/1 with valid data creates a server" do
      assert {:ok, %Server{}} = Meta.create_server(@valid_attrs)
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_server(@invalid_attrs)
    end

    test "create_server/1 with existing discord_id returns error changeset" do
      Meta.create_server(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Meta.create_server(@valid_attrs)
    end
  end
end

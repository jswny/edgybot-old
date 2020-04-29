defmodule Edgybot.ServersTest do
  use Edgybot.DataCase

  alias Edgybot.Meta

  describe "servers" do
    alias Edgybot.Meta.Server

    test "create_server/1 with valid data creates a server" do
      attrs = server_valid_attrs()
      assert {:ok, %Server{}} = Meta.create_server(attrs)
    end

    test "create_server/1 with invalid data returns error changeset" do
      attrs = server_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Meta.create_server(attrs)
    end

    test "create_server/1 with existing discord_id returns error changeset" do
      server_fixture()
      attrs = server_valid_attrs()
      assert {:error, %Ecto.Changeset{}} = Meta.create_server(attrs)
    end
  end
end

defmodule Edgybot.MetaTest do
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
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_server(attrs)
      assert %{discord_id: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "channels" do
    alias Edgybot.Meta.Channel

    test "create_channel/1 with valid data creates a channel" do
      attrs = channel_valid_attrs()
      assert {:ok, %Channel{}} = Meta.create_channel(attrs)
    end

    test "create_channel/1 with invalid data returns error changeset" do
      attrs = channel_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Meta.create_channel(attrs)
    end

    test "create_channel/1 with invalid server_id returns error changeset" do
      attrs = channel_valid_attrs(%{server_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_channel(attrs)
      assert %{server: ["does not exist"]} = errors_on(changeset)
    end

    test "create_channel/1 with existing discord_id returns error changeset" do
      channel = channel_fixture()
      attrs = channel_valid_attrs(%{server_id: channel.server_id})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_channel(attrs)
      assert %{discord_id: ["has already been taken"]} = errors_on(changeset)
    end
  end
end

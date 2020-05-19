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

    test "create_server/1 with invalid snowflake returns error changeset" do
      attrs = server_valid_attrs(%{snowflake: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_server(attrs)
      assert %{snowflake: ["invalid snowflake"]} = errors_on(changeset)
    end

    test "create_server/1 with existing snowflake returns error changeset" do
      server = server_fixture()
      attrs = server_valid_attrs(%{snowflake: server.snowflake})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_server(attrs)
      assert %{snowflake: ["has already been taken"]} = errors_on(changeset)
    end

    test "get_server/1 with valid snowflake returns server" do
      fixture = server_fixture()
      result = Meta.get_server(fixture.snowflake)
      assert %Server{} = result
    end

    test "get_server/1 with invalid snowflake returns nil" do
      server_fixture()
      result = Meta.get_server(-1)
      assert result == nil
    end
  end

  describe "users" do
    alias Edgybot.Meta.User

    test "create_user/1 with valid data creates a user" do
      attrs = user_valid_attrs()
      assert {:ok, %User{}} = Meta.create_user(attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      attrs = user_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Meta.create_user(attrs)
    end

    test "create_user/1 with invalid snowflake returns error changeset" do
      attrs = user_valid_attrs(%{snowflake: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_user(attrs)
      assert %{snowflake: ["invalid snowflake"]} = errors_on(changeset)
    end

    test "create_user/1 with existing snowflake returns error changeset" do
      user = user_fixture()
      attrs = user_valid_attrs(%{snowflake: user.snowflake})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_user(attrs)
      assert %{snowflake: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "members" do
    alias Edgybot.Meta.Member

    test "create_member/1 with valid data creates a member" do
      attrs = member_valid_attrs()
      assert {:ok, %Member{}} = Meta.create_member(attrs)
    end

    test "create_member/1 with invalid data returns error changeset" do
      attrs = member_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Meta.create_member(attrs)
    end

    test "create_member/1 with invalid user_id returns error changeset" do
      attrs = member_valid_attrs(%{user_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_member(attrs)
      assert %{user: ["does not exist"]} = errors_on(changeset)
    end

    test "create_member/1 with invalid server_id returns error changeset" do
      attrs = member_valid_attrs(%{server_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_member(attrs)
      assert %{server: ["does not exist"]} = errors_on(changeset)
    end

    test "create_member/1 with existing user_id and server_id returns error changeset" do
      member = member_fixture()
      attrs = member_valid_attrs(%{user_id: member.user_id, server_id: member.server_id})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_member(attrs)
      assert %{user_id: ["has already been taken"]} = errors_on(changeset)
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

    test "create_channel/1 with invalid snowflake returns error changeset" do
      attrs = channel_valid_attrs(%{snowflake: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_channel(attrs)
      assert %{snowflake: ["invalid snowflake"]} = errors_on(changeset)
    end

    test "create_channel/1 with invalid server_id returns error changeset" do
      attrs = channel_valid_attrs(%{server_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_channel(attrs)
      assert %{server: ["does not exist"]} = errors_on(changeset)
    end

    test "create_channel/1 with existing snowflake returns error changeset" do
      channel = channel_fixture()
      attrs = channel_valid_attrs(%{server_id: channel.server_id, snowflake: channel.snowflake})
      assert {:error, %Ecto.Changeset{} = changeset} = Meta.create_channel(attrs)
      assert %{snowflake: ["has already been taken"]} = errors_on(changeset)
    end
  end

  # describe "ensure_exists/1" do
  # end
end

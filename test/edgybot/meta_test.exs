defmodule Edgybot.MetaTest do
  use Edgybot.DataCase
  alias Edgybot.Meta
  alias Edgybot.Meta.{User, Server, Member, Channel}

  describe "servers" do
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
      assert result.name == fixture.name
    end

    test "get_server/1 with invalid snowflake returns nil" do
      result = Meta.get_server(-1)
      assert result == nil
    end
  end

  describe "users" do
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

    test "get_user/1 with valid snowflake returns user" do
      fixture = user_fixture()
      result = Meta.get_user(fixture.snowflake)
      assert %User{} = result
      assert result.username == fixture.username
    end

    test "get_user/1 with invalid snowflake returns nil" do
      result = Meta.get_user(-1)
      assert result == nil
    end
  end

  describe "members" do
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

    test "get_member/1 with valid snowflake returns member" do
      fixture = member_fixture()
      result = Meta.get_member(fixture.user_id, fixture.server_id)
      assert %Member{} = result
      assert result.nickname == fixture.nickname
    end

    test "get_member/1 with invalid snowflake returns nil" do
      result = Meta.get_member(-1, -1)
      assert result == nil
    end
  end

  describe "channels" do
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

    test "get_channel/1 with valid snowflake returns channel" do
      fixture = channel_fixture()
      result = Meta.get_channel(fixture.snowflake)
      assert %Channel{} = result
      assert result.name == fixture.name
    end

    test "get_channel/1 with invalid snowflake returns nil" do
      result = Meta.get_channel(-1)
      assert result == nil
    end
  end

  describe "ensure_exists/1" do
    test "returns the entity it creates" do
      attrs = server_valid_attrs()

      result = Meta.ensure_exists(
        server_snowflake: attrs.snowflake,
        get_server_remote: fn -> {:ok, struct(Server, attrs)} end
      )

      assert %Server{} = result
      assert result.name == attrs.name
    end

    test "creates server if it doesn't already exist" do
      attrs = server_valid_attrs()
      snowflake = attrs.snowflake

      Meta.ensure_exists(
        server_snowflake: snowflake,
        get_server_remote: fn -> {:ok, struct(Server, attrs)} end
      )

      result = Meta.get_server(snowflake)
      assert %Server{} = result
      assert result.name == attrs.name
    end

    test "uses existing server" do
      attrs = server_valid_attrs()
      snowflake = attrs.snowflake
      Meta.create_server(attrs)

      Meta.ensure_exists(
        server_snowflake: snowflake,
        get_server_remote: fn -> {:error, :nothing} end
      )

      result = Meta.get_server(snowflake)
      assert %Server{} = result
      assert result.name == attrs.name
    end

    test "creates channel if it doesn't already exist" do
      attrs = channel_valid_attrs()
      snowflake = attrs.snowflake

      Meta.ensure_exists(
        channel_snowflake: snowflake,
        get_channel_remote: fn -> {:ok, struct(Channel, attrs)} end
      )

      result = Meta.get_channel(snowflake)
      assert %Channel{} = result
      assert result.name == attrs.name
    end

    test "uses existing channel" do
      attrs = channel_valid_attrs()
      snowflake = attrs.snowflake
      Meta.create_channel(attrs)

      Meta.ensure_exists(
        channel_snowflake: snowflake,
        get_channel_remote: fn -> {:error, :nothing} end
      )

      result = Meta.get_channel(snowflake)
      assert %Channel{} = result
      assert result.name == attrs.name
    end

    test "creates user if it doesn't already exist" do
      attrs = user_valid_attrs()
      snowflake = attrs.snowflake

      Meta.ensure_exists(
        user_snowflake: snowflake,
        get_user_remote: fn -> {:ok, struct(User, attrs)} end
      )

      result = Meta.get_user(snowflake)
      assert %User{} = result
      assert result.username == attrs.username
    end

    test "creates user from attributes if it doesn't already exist" do
      attrs = user_valid_attrs()
      snowflake = attrs.snowflake

      Meta.ensure_exists(
        user_attrs: attrs
      )

      result = Meta.get_user(snowflake)
      assert %User{} = result
      assert result.username == attrs.username
    end

    test "uses existing user" do
      attrs = user_valid_attrs()
      snowflake = attrs.snowflake
      Meta.create_user(attrs)

      Meta.ensure_exists(
        user_snowflake: snowflake,
        get_user_remote: fn -> {:error, :nothing} end
      )

      result = Meta.get_user(snowflake)
      assert %User{} = result
      assert result.username == attrs.username
    end

    test "creates member if it doesn't already exist" do
      attrs = member_valid_attrs()
      user_id = attrs.user_id
      server_id = attrs.server_id

      Meta.ensure_exists(
        member_ids: {user_id, server_id},
        get_member_remote: fn -> {:ok, struct(Member, attrs)} end
      )

      result = Meta.get_member(user_id, server_id)
      assert %Member{} = result
      assert result.nickname == attrs.nickname
    end

    test "uses existing member" do
      attrs = member_valid_attrs()
      user_id = attrs.user_id
      server_id = attrs.server_id
      Meta.create_member(attrs)

      Meta.ensure_exists(
        member_ids: {user_id, server_id},
        get_member_remote: fn -> {:error, :nothing} end
      )

      result = Meta.get_member(user_id, server_id)
      assert %Member{} = result
      assert result.nickname == attrs.nickname
    end
  end
end

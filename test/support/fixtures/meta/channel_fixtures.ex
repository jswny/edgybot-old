defmodule Edgybot.Meta.ChannelFixtures do
  alias Edgybot.Meta
  import Edgybot.Meta.ServerFixtures

  def channel_valid_attrs(attrs \\ %{}) do
    %{
      snowflake: 200317799350927360,
      name: "foo",
      server_id: Map.get(attrs, :server_id) || server_fixture().id
    }
  end

  def channel_invalid_attrs(), do: %{snowflake: nil, name: nil, server_id: nil}

  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(channel_valid_attrs())
      |> Meta.create_channel()

    channel
  end
end

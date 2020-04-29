defmodule Edgybot.Meta.ChannelFixtures do
  alias Edgybot.Meta
  import Edgybot.Meta.ServerFixtures

  def channel_valid_attrs(attrs \\ %{}) do
    %{
      discord_id: "123",
      name: "foo",
      server_id: Map.get(attrs, :server_id) || server_fixture().id
    }
  end

  def channel_invalid_attrs(), do: %{discord_id: nil, name: nil, server_id: nil}

  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(channel_valid_attrs())
      |> Meta.create_channel()

    channel
  end
end

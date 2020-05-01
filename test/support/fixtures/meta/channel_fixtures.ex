defmodule Edgybot.Meta.ChannelFixtures do
  import Edgybot.TestUtils
  import Edgybot.Meta.ServerFixtures
  alias Edgybot.Meta

  def channel_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      snowflake: random_number(),
      name: random_string(),
      server_id: Map.get(attrs, :server_id) || server_fixture().id
    })
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

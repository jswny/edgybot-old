defmodule Edgybot.Meta.ServerFixtures do
  import Edgybot.TestUtils
  alias Edgybot.Meta
  alias Edgybot.Meta.Server

  def server_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      snowflake: random_number(),
      name: random_string(),
      active: true
    })
  end

  def server_invalid_attrs(), do: %{snowflake: nil, name: nil, active: nil}

  def server_fixture(attrs \\ %{}) do
    {:ok, server} =
      attrs
      |> Enum.into(server_valid_attrs())
      |> Meta.create_server()

    server
  end

  def to_server_struct(attrs) when is_map(attrs) do
    %Server{
      id: 123,
      name: attrs.name,
      snowflake: attrs.snowflake,
      active: attrs.active
    }
  end
end

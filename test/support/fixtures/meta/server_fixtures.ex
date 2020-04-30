defmodule Edgybot.Meta.ServerFixtures do
  alias Edgybot.Meta

  def server_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      snowflake: 200317799350927360,
      name: "foo",
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
end

defmodule Edgybot.Meta.UserFixtures do
  import Edgybot.TestUtils
  alias Edgybot.Meta

  def user_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      snowflake: random_number(),
      username: random_string(),
      discriminator: random_discriminator(),
    })
  end

  def user_invalid_attrs(), do: %{snowflake: nil, username: nil, discriminator: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(user_valid_attrs())
      |> Meta.create_user()

    user
  end
end

defmodule Edgybot.Meta.UserFixtures do
  alias Edgybot.Meta

  def user_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      snowflake: 200317799350927360,
      username: "foo",
      discriminator: "1234",
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

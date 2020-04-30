defmodule Edgybot.Meta.MemberFixtures do
  alias Edgybot.Meta
  import Edgybot.Meta.UserFixtures
  import Edgybot.Meta.ServerFixtures

  def member_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      nickname: "foo",
      user_id: Map.get(attrs, :user_id) || user_fixture().id,
      server_id: Map.get(attrs, :server_id) || server_fixture().id
    })
  end

  def member_invalid_attrs(), do: %{nickname: nil, user_id: nil, server_id: nil}

  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(member_valid_attrs())
      |> Meta.create_member()

    member
  end
end

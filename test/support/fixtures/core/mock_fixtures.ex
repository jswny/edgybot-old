defmodule Edgybot.Core.MockFixtures do
  alias Edgybot.Core
  import Edgybot.Meta.MemberFixtures

  def mock_valid_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      mocker_member_id: Map.get(attrs, :mocker_member_id) || member_fixture().id,
      mockee_member_id: Map.get(attrs, :mockee_member_id) || member_fixture().id
    })
  end

  def mock_invalid_attrs(), do: %{mocker_member_id: nil, mockee_member_id: nil}

  def mock_fixture(attrs \\ %{}) do
    {:ok, mock} =
      attrs
      |> Enum.into(mock_valid_attrs())
      |> Core.create_mock()
    mock
  end
end

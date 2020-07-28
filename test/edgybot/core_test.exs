defmodule Edgybot.CoreTest do
  use Edgybot.DataCase
  alias Edgybot.Core

  describe "mocks" do
    alias Edgybot.Core.Mock

    test "create_mock/1 with valid data creates a mock" do
      attrs = mock_valid_attrs()
      assert {:ok, %Mock{}} = Core.create_mock(attrs)
    end

    test "create_mock/1 with invalid data returns error changeset" do
      attrs = mock_invalid_attrs()
      assert {:error, %Ecto.Changeset{}} = Core.create_mock(attrs)
    end

    test "create_mock/1 with invalid mocker_member_id returns error changeset" do
      attrs = mock_valid_attrs(%{mocker_member_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Core.create_mock(attrs)
      assert %{mocker_member: ["does not exist"]} = errors_on(changeset)
    end

    test "create_mock/1 with invalid mockee_member_id returns error changeset" do
      attrs = mock_valid_attrs(%{mockee_member_id: -1})
      assert {:error, %Ecto.Changeset{} = changeset} = Core.create_mock(attrs)
      assert %{mockee_member: ["does not exist"]} = errors_on(changeset)
    end

    test "create_mock/1 with existing mocker_member_id and mockee_member_id returns error changeset" do
      mock = mock_fixture()
      attrs = mock_valid_attrs(%{mocker_member_id: mock.mocker_member_id, mockee_member_id: mock.mockee_member_id})
      assert {:error, %Ecto.Changeset{} = changeset} = Core.create_mock(attrs)
      assert %{mocker_member_id: ["has already been taken"]} = errors_on(changeset)
    end
  end
end

defmodule Edgybot.Core.Mock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edgybot.Meta.Member

  @primary_key false
  schema "mocks" do
    belongs_to :mocker, Member, [foreign_key: :mocker_member_id]
    belongs_to :mockee, Member, [foreign_key: :mockee_member_id]

    timestamps()
  end

  def changeset(member, params \\ %{}) do
    member
    |> cast(params, [:mocker_member_id, :mockee_member_id])
    |> validate_required([:mocker_member_id, :mockee_member_id])
    |> assoc_constraint(:member, name: :mocks_mocker_member_id_fkey)
    |> assoc_constraint(:member, name: :mocks_mockee_member_id_fkey)
    |> unique_constraint([:mocker_member_id, :mockee_member_id])
  end
end

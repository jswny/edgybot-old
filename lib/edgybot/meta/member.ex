defmodule Edgybot.Meta.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edgybot.Meta.{User, Server}

  @primary_key false
  schema "members" do
    field :nickname, :string
    belongs_to :user, User
    belongs_to :server, Server

    timestamps()
  end

  def changeset(member, params \\ %{}) do
    member
    |> cast(params, [:nickname, :user_id, :server_id])
    |> validate_required([:nickname, :user_id, :server_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:server)
    |> unique_constraint([:user_id, :server_id])
  end
end

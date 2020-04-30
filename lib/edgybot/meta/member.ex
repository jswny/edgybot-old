defmodule Edgybot.Meta.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edgybot.Meta.{User, Server}

  @primary_key false
  schema "members" do
    field :nickname, :string
    belongs_to :user, User, primary_key: true
    belongs_to :server, Server, primary_key: true

    timestamps()
  end

  def changeset(member, params \\ %{}) do
    member
    |> cast(params, [:nickname, :user_id, :server_id])
    |> validate_required([:nickname, :user_id, :server_id])
    |> unique_constraint([:user_id, :server_id])
  end
end

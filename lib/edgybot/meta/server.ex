defmodule Edgybot.Meta.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :discord_id, :string
    field :name, :string
    field :active, :boolean

    timestamps()
  end

  def changeset(server, params \\ %{}) do
    server
    |> cast(params, [:discord_id, :name, :active])
    |> validate_required([:discord_id, :name, :active])
    |> unique_constraint(:discord_id)
  end
end

defmodule Edgybot.Meta.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :discord_id, :string
    field :name, :string

    timestamps()
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [:discord_id, :name])
    |> validate_required([:discord_id, :name])
    |> unique_constraint(:discord_id)
  end
end

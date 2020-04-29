defmodule Edgybot.Meta.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edgybot.Meta.Server

  schema "channels" do
    field :discord_id, :string
    field :name, :string
    belongs_to :server, Server

    timestamps()
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [:discord_id, :name, :server_id])
    |> validate_required([:discord_id, :name, :server_id])
    |> assoc_constraint(:server)
    |> unique_constraint(:discord_id)
  end
end

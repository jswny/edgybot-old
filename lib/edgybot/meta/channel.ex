defmodule Edgybot.Meta.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  import Edgybot.Meta.Snowflake
  alias Edgybot.Meta.Server

  schema "channels" do
    field :snowflake, :integer
    field :name, :string
    belongs_to :server, Server

    timestamps()
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [:snowflake, :name, :server_id])
    |> validate_required([:snowflake, :name, :server_id])
    |> validate_snowflake(:snowflake)
    |> assoc_constraint(:server)
    |> unique_constraint(:snowflake)
  end
end

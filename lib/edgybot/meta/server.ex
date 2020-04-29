defmodule Edgybot.Meta.Server do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edgybot.Meta.Channel
  import Edgybot.Meta.Snowflake

  schema "servers" do
    field :snowflake, :integer
    field :name, :string
    field :active, :boolean
    has_many :channels, Channel

    timestamps()
  end

  def changeset(server, params \\ %{}) do
    server
    |> cast(params, [:snowflake, :name, :active])
    |> validate_required([:snowflake, :name, :active])
    |> validate_snowflake(:snowflake)
    |> unique_constraint(:snowflake)
  end
end

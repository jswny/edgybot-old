defmodule Edgybot.Meta.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :snowflake, :integer
    field :name, :string
    field :active, :boolean

    timestamps()
  end

  def changeset(server, params \\ %{}) do
    server
    |> cast(params, [:snowflake, :name, :active])
    |> validate_required([:snowflake, :name, :active])
    |> unique_constraint(:snowflake)
  end
end

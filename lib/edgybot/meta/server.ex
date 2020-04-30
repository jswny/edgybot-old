defmodule Edgybot.Meta.Server do
  use Ecto.Schema
  import Ecto.Changeset
  import Edgybot.Meta.Snowflake
  alias Edgybot.Meta.{Channel, Member}

  schema "servers" do
    field :snowflake, :integer
    field :name, :string
    field :active, :boolean
    has_many :channels, Channel
    has_many :members, Member

    timestamps()
  end

  def changeset(server, params \\ %{}) do
    server
    |> cast(params, [:snowflake, :name, :active])
    |> validate_required([:snowflake, :name])
    |> validate_snowflake(:snowflake)
    |> unique_constraint(:snowflake)
  end
end

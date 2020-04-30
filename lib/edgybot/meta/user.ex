defmodule Edgybot.Meta.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Edgybot.Meta.Snowflake
  alias Edgybot.Meta.Member

  schema "users" do
    field :snowflake, :integer
    field :username, :string
    field :discriminator, :string
    field :bot, :boolean
    has_many :members, Member

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:snowflake, :username, :discriminator, :bot])
    |> validate_required([:snowflake, :username, :discriminator])
    |> validate_snowflake(:snowflake)
    |> unique_constraint(:snowflake)
  end
end

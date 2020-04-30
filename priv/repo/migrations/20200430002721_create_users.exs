defmodule Edgybot.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :snowflake, :bigint, null: false
      add :username, :string, null: false
      add :discriminator, :string, null: false, default: true
      add :bot, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:users, [:snowflake])
  end
end

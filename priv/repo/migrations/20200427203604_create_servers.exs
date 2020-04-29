defmodule Edgybot.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :discord_id, :string, null: false
      add :name, :string, null: false
      add :active, :boolean, null: false

      timestamps()
    end

    create unique_index(:servers, [:discord_id])
  end
end

defmodule Edgybot.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :discord_id, :string
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:servers, [:discord_id])
  end
end

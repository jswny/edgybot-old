defmodule Edgybot.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :discord_id, :string, null: false
      add :name, :string, null: false
      add :server_id, references(:servers)

      timestamps()
    end

    create unique_index(:channels, [:discord_id])
  end
end

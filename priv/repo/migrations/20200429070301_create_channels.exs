defmodule Edgybot.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :snowflake, :bigint, null: false
      add :name, :string, null: false
      add :server_id, references(:servers), null: false

      timestamps()
    end

    create unique_index(:channels, [:snowflake])
  end
end

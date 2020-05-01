defmodule Edgybot.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :nickname, :string
      add :user_id, references(:users)
      add :server_id, references(:servers)

      timestamps()
    end

    create unique_index(:members, [:user_id, :server_id])
  end
end

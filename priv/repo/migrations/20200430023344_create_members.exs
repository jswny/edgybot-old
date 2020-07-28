defmodule Edgybot.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :nickname, :string, null: false
      add :user_id, references(:users), null: false
      add :server_id, references(:servers), null: false

      timestamps()
    end

    create unique_index(:members, [:user_id, :server_id])
  end
end

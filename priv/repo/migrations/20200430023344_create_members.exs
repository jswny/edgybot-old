defmodule Edgybot.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :nickname, :string
      add :user_id, references(:users), primary_key: true
      add :server_id, references(:servers), primary_key: true

      timestamps()
    end
  end
end

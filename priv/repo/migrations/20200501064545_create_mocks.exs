defmodule Edgybot.Repo.Migrations.CreateMocks do
  use Ecto.Migration

  def change do
    create table(:mocks) do
      add :mocker_member_id, :integer, null: false
      add :mockee_member_id, :integer, null: false

      timestamps()
    end

    create unique_index(:mocks, [:mocker_member_id, :mockee_member_id])
  end
end

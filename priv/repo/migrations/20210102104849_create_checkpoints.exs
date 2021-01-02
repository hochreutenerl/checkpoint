defmodule Checkpoint.Repo.Migrations.CreateCheckpoints do
  use Ecto.Migration

  def change do
    create table(:checkpoints) do
      add :name, :string
      add :lat, :float
      add :long, :float
      add :run_id, references(:runs, on_delete: :nothing)

      timestamps()
    end

    create index(:checkpoints, [:run_id])
  end
end

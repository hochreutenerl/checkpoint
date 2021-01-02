defmodule Checkpoint.Repo.Migrations.CreateCheckins do
  use Ecto.Migration

  def change do
    create table(:checkins) do
      add :time, :naive_datetime
      add :lat, :float
      add :long, :float
      add :checkpoint_id, references(:checkpoints, on_delete: :nothing)

      timestamps()
    end

    create index(:checkins, [:checkpoint_id])
  end
end

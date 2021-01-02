defmodule Checkpoint.Repo.Migrations.CreateRuns do
  use Ecto.Migration

  def change do
    create table(:runs) do
      add :name, :string
      add :start, :naive_datetime
      add :end, :naive_datetime

      timestamps()
    end

  end
end

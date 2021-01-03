defmodule Checkpoint.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string
      add :password, :string
      add :admin, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index :users, [:name]
    create unique_index :users, [:email]
  end
end

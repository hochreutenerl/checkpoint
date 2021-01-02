defmodule Checkpoint.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkpoints" do
    field :lat, :float
    field :long, :float
    field :name, :string
    field :run_id, :id

    timestamps()
  end

  @doc false
  def changeset(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :lat, :long])
    |> validate_required([:name, :lat, :long])
  end
end

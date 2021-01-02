defmodule Checkpoint.Run do
  use Ecto.Schema
  import Ecto.Changeset

  schema "runs" do
    field :end, :naive_datetime
    field :name, :string
    field :start, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(run, attrs) do
    run
    |> cast(attrs, [:name, :start, :end])
    |> validate_required([:name, :start, :end])
  end
end

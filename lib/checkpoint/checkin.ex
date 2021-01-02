defmodule Checkpoint.Checkin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkins" do
    field :lat, :float
    field :long, :float
    field :time, :naive_datetime
    field :checkpoint_id, :id

    timestamps()
  end

  @doc false
  def changeset(checkin, attrs) do
    checkin
    |> cast(attrs, [:time, :lat, :long])
    |> validate_required([:time, :lat, :long])
  end
end

defmodule Checkpoint.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :password_clear, :string, virtual: true
    field :admin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> unique_constraint(:name, name: :users_name_index)
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password_clear)a, [])
    |> validate_length(:password_clear, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{
          password_clear: password_clear
        }
      } ->
        put_change(
          changeset,
          :password,
          Comeonin.Bcrypt.hashpwsalt(password_clear)
        )
      _ ->
        changeset
    end

  end

end
defmodule CheckpointWeb.SessionController do
  use CheckpointWeb, :controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Checkpoint.User
  alias Checkpoint.Repo

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email,
    "password" => password}}) do
    case CheckpointWeb.Auth.login_by_email_and_pass(conn, email,
           password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now signed in!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ChekpointWeb.Auth.logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
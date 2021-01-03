defmodule CheckpointWeb.RunController do
  use CheckpointWeb, :controller

  alias Checkpoint.Run
  alias Checkpoint.User
  alias Checkpoint.Repo

  plug :scrub_params, "run" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    runs = Repo.all
    render(conn, "index.html", runs: runs)
  end

  def show(conn, %{"id" => id}, current_user) do
    runs = Repo.all
    render(conn, "index.html", runs: runs)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> Run.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"run" => run_params}, current_user) do
    changeset = Run.changeset(run_params)
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Run was created successfully")
        |> redirect(to: Routes.run_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    run = Repo.get(Run, id)
    if run do
      changeset = Run.changeset(run)
      render(conn, "edit.html", run: run, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(CheckpointWeb.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "run" => run_params}, current_user) do
    run = Repo.get(Run, id)
    changeset = Run.changeset(run, run_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Run was updated successfully")
        |> redirect(to: Routes.run_path(conn, :show, current_user.id,
          run.id))
      {:error, changeset} ->
        render(conn, "edit.html", run: run, changeset: changeset)
    end
  end
  
  def delete(conn, %{"id" => id}, current_user) do
    run = Repo.get(Run, id) |> Repo.delete!
    conn
    |> put_flash(:info, "Run was deleted successfully")
    |> redirect(to: Routes.run_path(conn, :index, current_user.id))
  end

end

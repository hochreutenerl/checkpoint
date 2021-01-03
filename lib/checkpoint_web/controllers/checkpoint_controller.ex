defmodule CheckpointWeb.CheckpointController do
  use CheckpointWeb, :controller

  alias Checkpoint.Checkpoint
  alias Checkpoint.Run


  plug :scrub_params, "checkpoint" when action in [:create, :update]

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end

  def index(conn, %{"run_id" => run_id}, _current_user) do
    user = Run
           |> Repo.get!(run_id)
    checkpoints =
      user
      |> run_checkpoints
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", checkpoints: checkpoints, user: user)
  end

  def show(conn, %{"run_id" => run_id, "id" => id}, _current_user) do
    user = Run
           |> Repo.get!(run_id)
    checkpoints =
      user
      |> run_checkpoints
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", checkpoints: checkpoints, user: user)
  end


 # def new(conn, _params, current_user) do
 #   changeset =
 #     current_user
 #     |> build_assoc(:checkpoints)
 #     |> Checkpoint.changeset
 #   render(conn, "new.html", changeset: changeset)
 # end
#
 # def create(conn, %{"checkpoint" => checkpoint_params}, current_user) do
 #   changeset =
 #     current_user
 #     |> build_assoc(:checkpoints)
 #     |> Checkpoint.changeset(checkpoint_params)
 #   case Repo.insert(changeset) do
 #     {:ok, _} ->
 #       conn
 #       |> put_flash(:info, "Checkpoint was created successfully")
 #       |> redirect(to: user_checkpoint_path(conn, :index, current_user.id))
 #     {:error, changeset} ->
 #       render(conn, "new.html", changeset: changeset)
 #   end
 # end

  def edit(conn, %{"id" => id}, current_user) do
    checkpoint = current_user
                 |> run_checkpoint_by_id(id)
    if checkpoint do
      changeset = Checkpoint.changeset(checkpoint)
      render(conn, "edit.html", checkpoint: checkpoint, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(CheckpointWeb.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "checkpoint" => checkpoint_params}, current_user) do
    checkpoint = current_user
                 |> run_checkpoint_by_id(id)
    changeset = Checkpoint.changeset(checkpoint, checkpoint_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Checkpoint was updated successfully")
        |> redirect(
             to: Routes.run_checkpoint_path(
               conn,
               :show,
               current_user.id,
               checkpoint.id
             )
           )
      {:error, changeset} ->
        render(conn, "edit.html", checkpoint: checkpoint, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    current_user
    |> run_checkpoint_by_id(id)
    |> Repo.delete!
    conn
    |> put_flash(:info, "Checkpoint was deleted successfully")
    |> redirect(to: Routes.run_checkpoint_path(conn, :index, current_user.id))
  end

  defp run_checkpoints(run) do
    Ecto.assoc(run, :checkpoints)
  end

  defp run_checkpoint_by_id(run, checkpoint_id) do
    run
    |> run_checkpoints
    |> Repo.get(checkpoint_id)
  end

end

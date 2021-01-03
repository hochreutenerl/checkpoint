defmodule CheckpointWeb.CheckinController do
  use CheckpointWeb, :controller

  alias Checkin.Checkin
  alias Checkin.Checkpoint


  plug :scrub_params, "checkin" when action in [:create, :update]

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end

  def index(conn, %{"checkpoint_id" => checkpoint_id}, _current_user) do
    user = Checkpoint
           |> Repo.get!(checkpoint_id)
    checkins =
      user
      |> checkpoint_checkins
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", checkins: checkins, user: user)
  end

  def show(conn, %{"checkpoint_id" => checkpoint_id, "id" => id}, _current_user) do
    user = Checkpoint
           |> Repo.get!(checkpoint_id)
    checkins =
      user
      |> checkpoint_checkins
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", checkins: checkins, user: user)
  end


  # def new(conn, _params, current_user) do
  #   changeset =
  #     current_user
  #     |> build_assoc(:checkins)
  #     |> Checkin.changeset
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"checkin" => checkin_params}, current_user) do
  #   changeset =
  #     current_user
  #     |> build_assoc(:checkins)
  #     |> Checkin.changeset(checkin_params)
  #   case Repo.insert(changeset) do
  #     {:ok, _} ->
  #       conn
  #       |> put_flash(:info, "Checkin was created successfully")
  #       |> redirect(to: user_checkin_path(conn, :index, current_user.id))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def edit(conn, %{"id" => id}, current_user) do
    checkin = current_user
                 |> checkpoint_checkin_by_id(id)
    if checkin do
      changeset = Checkin.changeset(checkin)
      render(conn, "edit.html", checkin: checkin, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(CheckpointWeb.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "checkin" => checkin_params}, current_user) do
    checkin = current_user
                 |> checkpoint_checkin_by_id(id)
    changeset = Checkin.changeset(checkin, checkin_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Checkin was updated successfully")
        |> redirect(
             to: Routes.checkpoint_checkin_path(
               conn,
               :show,
               current_user.id,
               checkin.id
             )
           )
      {:error, changeset} ->
        render(conn, "edit.html", checkin: checkin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    current_user
    |> checkpoint_checkin_by_id(id)
    |> Repo.delete!
    conn
    |> put_flash(:info, "Checkin was deleted successfully")
    |> redirect(to: Routes.checkpoint_checkin_path(conn, :index, current_user.id))
  end

  defp checkpoint_checkins(checkpoint) do
    Ecto.assoc(checkpoint, :checkins)
  end

  defp checkpoint_checkin_by_id(checkpoint, checkin_id) do
    checkpoint
    |> checkpoint_checkins
    |> Repo.get(checkin_id)
  end

end

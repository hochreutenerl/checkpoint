defmodule CheckpointWeb.Router do
  use CheckpointWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CheckpointWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug CheckpointWeb.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: CheckpointWeb.GuardianErrorHandler
  end

  pipeline :admin_required do
  end

  scope "/", CheckpointWeb do
    pipe_through [:browser, :with_session]

    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    live "/", PageLive, :index

    scope "/" do
      pipe_through [:login_required]

      resources "/users", UserController, only: [:show]
      resources "/run", RunController
      resources "/checkpoint", CheckpointController
      resources "/checkin", CheckinController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CheckpointWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CheckpointWeb.Telemetry
    end
  end
end

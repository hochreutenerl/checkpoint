# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :checkpoint,
  ecto_repos: [Checkpoint.Repo]

# Configures the endpoint
config :checkpoint, CheckpointWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KYMLmr8qwI9+CRSu571G3MwLYXL7X1/wOgyqaPvcpOyjlaSshGS6T4wYkJ++P6IW",
  render_errors: [view: CheckpointWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Checkpoint.PubSub,
  live_view: [signing_salt: "YldH19Xg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

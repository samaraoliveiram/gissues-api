# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gissues,
  ecto_repos: [Gissues.Repo]

# Configures the endpoint
config :gissues, GissuesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qva9GsbFWNoa9/XKWtTISlzv+a/yCHWvt8yQol/RnJ03ag7eeHvP6OAv1EGsWtt+",
  render_errors: [view: GissuesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Gissues.PubSub,
  live_view: [signing_salt: "tHSfMsiQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :gissues, Oban,
  repo: Gissues.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :gissues, :gh_token, System.get_env("GH_TOKEN")
config :gissues, :base_url, "https://api.github.com"
config :gissues, :per_page, 100

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

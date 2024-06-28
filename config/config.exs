# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ash_notifications_bug_repro,
  ecto_repos: [AshNotificationsBugRepro.Repo],
  generators: [timestamp_type: :utc_datetime],
  ash_domains: [
     AshNotificationsBugRepro.Garage,
  ]

# Configures the endpoint
config :ash_notifications_bug_repro, AshNotificationsBugReproWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AshNotificationsBugReproWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AshNotificationsBugRepro.PubSub,
  live_view: [signing_salt: "kECVj0dL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ash 
config :spark, :formatter,
  remove_parens?: true,
  "Ash.Domain": [],
  "Ash.Resource": [
    section_order: [
      # any section not in this list is left where it is
      # but these sections will always appear in this order in a resource
      :code_interface,
      :actions,
      :pub_sub,
      :attributes,
      :aggregates,
      :relationships,
      :identities,
      :postgres
    ]
  ]

config :ash, :pub_sub, debug?: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

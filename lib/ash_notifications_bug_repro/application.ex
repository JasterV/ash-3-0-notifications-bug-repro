defmodule AshNotificationsBugRepro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AshNotificationsBugReproWeb.Telemetry,
      AshNotificationsBugRepro.Repo,
      {DNSCluster, query: Application.get_env(:ash_notifications_bug_repro, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshNotificationsBugRepro.PubSub},
      # Start a worker by calling: AshNotificationsBugRepro.Worker.start_link(arg)
      # {AshNotificationsBugRepro.Worker, arg},
      # Start to serve requests, typically the last entry
      AshNotificationsBugReproWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshNotificationsBugRepro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshNotificationsBugReproWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

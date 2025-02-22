defmodule FlyHealthCheck.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlyHealthCheckWeb.Telemetry,
      FlyHealthCheck.Repo,
      {DNSCluster, query: Application.get_env(:fly_health_check, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FlyHealthCheck.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FlyHealthCheck.Finch},
      # Start a worker by calling: FlyHealthCheck.Worker.start_link(arg)
      # {FlyHealthCheck.Worker, arg},
      # Start to serve requests, typically the last entry
      FlyHealthCheckWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlyHealthCheck.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlyHealthCheckWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

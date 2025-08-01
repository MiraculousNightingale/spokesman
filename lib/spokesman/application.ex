defmodule Spokesman.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpokesmanWeb.Telemetry,
      Spokesman.Repo,
      {DNSCluster, query: Application.get_env(:spokesman, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Spokesman.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Spokesman.Finch},
      # Start a worker by calling: Spokesman.Worker.start_link(arg)
      # {Spokesman.Worker, arg},
      # Start to serve requests, typically the last entry
      SpokesmanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spokesman.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpokesmanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

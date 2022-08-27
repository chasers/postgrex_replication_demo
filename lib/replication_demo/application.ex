defmodule ReplicationDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    repl_opts = Application.get_env(:replication_demo, ReplicationDemo.Repo)

    children = [
      # Start the Ecto repository
      ReplicationDemo.Repo,
      # Start Postgres replication
      {ReplicationDemo.Replication, repl_opts},
      # Start the Telemetry supervisor
      ReplicationDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ReplicationDemo.PubSub},
      # Start the Endpoint (http/https)
      ReplicationDemoWeb.Endpoint
      # Start a worker by calling: ReplicationDemo.Worker.start_link(arg)
      # {ReplicationDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReplicationDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReplicationDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

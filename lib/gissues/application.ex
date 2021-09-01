defmodule Gissues.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Gissues.Repo,
      # Start the Telemetry supervisor
      GissuesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gissues.PubSub},
      # Start the Endpoint (http/https)
      GissuesWeb.Endpoint,
      # Start a worker by calling: Gissues.Worker.start_link(arg)
      {Oban, Application.get_env(:gissues, Oban)}
      # {Gissues.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gissues.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GissuesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

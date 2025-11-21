defmodule WebhookBucket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WebhookBucketWeb.Telemetry,
      WebhookBucket.Repo,
      {DNSCluster, query: Application.get_env(:webhook_bucket, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WebhookBucket.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WebhookBucket.Finch},
      # Start a worker by calling: WebhookBucket.Worker.start_link(arg)
      # {WebhookBucket.Worker, arg},
      # Start to serve requests, typically the last entry
      WebhookBucketWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebhookBucket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebhookBucketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

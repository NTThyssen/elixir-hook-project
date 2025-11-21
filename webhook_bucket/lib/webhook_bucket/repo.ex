defmodule WebhookBucket.Repo do
  use Ecto.Repo,
    otp_app: :webhook_bucket,
    adapter: Ecto.Adapters.Postgres
end

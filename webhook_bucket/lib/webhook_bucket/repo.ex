defmodule WebhookBucket.Repo do
  use Ecto.Repo,
    otp_app: :webhook_bucket,
    adapter: Application.compile_env!(:webhook_bucket, [WebhookBucket.Repo, :adapter])
end

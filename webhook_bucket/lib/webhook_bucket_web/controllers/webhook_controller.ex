defmodule WebhookBucketWeb.WebhookController do
  use WebhookBucketWeb, :controller
  alias WebhookBucket.Buckets
  alias WebhookBucket.Webhooks
  alias WebhookBucket.Repo

  def create(conn, %{"slug" => slug}) do
    # 1. Find the bucket
    case Buckets.get_bucket_by_slug(slug) do
      nil ->
        send_resp(conn, 404, "Bucket not found")

      bucket ->
        # 2. Capture details
        request_params = %{
          bucket_id: bucket.id,
          method: conn.method,
          headers: Enum.into(conn.req_headers, %{}),
          body: conn.body_params
        }

        # 3. Save to DB
        {:ok, request} = Webhooks.create_request(request_params)

        # 4. BROADCAST via PubSub
        Phoenix.PubSub.broadcast(
          WebhookBucket.PubSub,
          "bucket:#{slug}",
          {:new_request, request}
        )

        send_resp(conn, 200, "Received")
    end
  end
end

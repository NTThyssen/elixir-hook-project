defmodule WebhookBucketWeb.WebhookControllerTest do
  use WebhookBucketWeb.ConnCase
  alias WebhookBucket.Buckets
  alias WebhookBucket.Webhooks

  test "POST /hook/:slug receives webhook", %{conn: conn} do
    {:ok, bucket} = Buckets.create_bucket(%{
      user_id: "test_user",
      unique_slug: "test-bucket",
      target_url: "http://example.com"
    })

    conn = post(conn, ~p"/hook/#{bucket.unique_slug}", %{some: "data"})
    assert response(conn, 200) == "Received"

    [request] = Webhooks.list_requests(bucket.id)
    assert request.body == %{"some" => "data"}
    assert request.method == "POST"
  end

  test "POST /hook/:slug returns 404 for unknown bucket", %{conn: conn} do
    conn = post(conn, ~p"/hook/unknown-bucket", %{some: "data"})
    assert response(conn, 404) == "Bucket not found"
  end
end

defmodule WebhookBucketWeb.BucketLiveTest do
  use WebhookBucketWeb.ConnCase
  import Phoenix.LiveViewTest
  alias WebhookBucket.Buckets
  alias WebhookBucket.Webhooks

  test "displays requests", %{conn: conn} do
    {:ok, bucket} = Buckets.create_bucket(%{
      user_id: "test_user",
      unique_slug: "test-bucket-live",
      target_url: "http://example.com"
    })

    {:ok, request} = Webhooks.create_request(%{
      bucket_id: bucket.id,
      method: "POST",
      headers: %{},
      body: %{"hello" => "world"}
    })

    {:ok, _view, html} = live(conn, ~p"/bucket/#{bucket.unique_slug}")
    assert html =~ "Bucket: test-bucket-live"
    assert html =~ "POST"
    assert html =~ "world"
  end

  test "receives updates via PubSub", %{conn: conn} do
    {:ok, bucket} = Buckets.create_bucket(%{
      user_id: "test_user",
      unique_slug: "test-bucket-pubsub",
      target_url: "http://example.com"
    })

    {:ok, view, _html} = live(conn, ~p"/bucket/#{bucket.unique_slug}")

    # Simulate incoming webhook
    request_params = %{
      bucket_id: bucket.id,
      method: "GET",
      headers: %{},
      body: %{"new" => "request"}
    }
    {:ok, request} = Webhooks.create_request(request_params)

    Phoenix.PubSub.broadcast(
      WebhookBucket.PubSub,
      "bucket:#{bucket.unique_slug}",
      {:new_request, request}
    )

    assert render(view) =~ "GET"
    assert render(view) =~ "new"
  end
end

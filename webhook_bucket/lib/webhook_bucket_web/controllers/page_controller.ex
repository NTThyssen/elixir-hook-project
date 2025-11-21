defmodule WebhookBucketWeb.PageController do
  use WebhookBucketWeb, :controller
  alias WebhookBucket.Buckets

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end

  def create_bucket(conn, _params) do
    slug = Nanoid.generate()
    # In a real app, we would create the bucket here.
    # For MVP, we just redirect to the live view which will handle "not found" or we can pre-create it.
    # Let's create it.

    case Buckets.create_bucket(%{
      user_id: "anonymous", # For MVP
      unique_slug: slug,
      target_url: "http://localhost:4000/api/webhook" # Default
    }) do
      {:ok, _bucket} ->
        redirect(conn, to: ~p"/bucket/#{slug}")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Could not create bucket")
        |> redirect(to: ~p"/")
    end
  end
end

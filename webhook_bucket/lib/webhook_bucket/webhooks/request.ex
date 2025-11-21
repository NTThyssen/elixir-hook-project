defmodule WebhookBucket.Webhooks.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :body, :map
    field :headers, :map
    field :method, :string
    belongs_to :bucket, WebhookBucket.Buckets.Bucket

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:headers, :body, :method, :bucket_id])
    |> validate_required([:method, :bucket_id])
  end
end

defmodule WebhookBucket.Buckets.Bucket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buckets" do
    field :target_url, :string
    field :unique_slug, :string
    field :user_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bucket, attrs) do
    bucket
    |> cast(attrs, [:user_id, :unique_slug, :target_url])
    |> validate_required([:user_id, :unique_slug, :target_url])
    |> unique_constraint(:unique_slug)
  end
end

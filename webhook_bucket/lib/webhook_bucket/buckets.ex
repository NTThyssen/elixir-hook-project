defmodule WebhookBucket.Buckets do
  @moduledoc """
  The Buckets context.
  """

  import Ecto.Query, warn: false
  alias WebhookBucket.Repo
  alias WebhookBucket.Buckets.Bucket

  @doc """
  Gets a single bucket by slug.

  Raises `Ecto.NoResultsError` if the Bucket does not exist.

  ## Examples

      iex> get_bucket_by_slug("w4t3r-m3l0n")
      %Bucket{}

      iex> get_bucket_by_slug("bad-slug")
      nil

  """
  def get_bucket_by_slug(slug) do
    Repo.get_by(Bucket, unique_slug: slug)
  end

  @doc """
  Creates a bucket.

  ## Examples

      iex> create_bucket(%{field: value})
      {:ok, %Bucket{}}

      iex> create_bucket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bucket(attrs \\ %{}) do
    %Bucket{}
    |> Bucket.changeset(attrs)
    |> Repo.insert()
  end
end

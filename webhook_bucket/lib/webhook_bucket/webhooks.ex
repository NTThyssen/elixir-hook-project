defmodule WebhookBucket.Webhooks do
  @moduledoc """
  The Webhooks context.
  """

  import Ecto.Query, warn: false
  alias WebhookBucket.Repo
  alias WebhookBucket.Webhooks.Request

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def list_requests(bucket_id) do
    from(r in Request, where: r.bucket_id == ^bucket_id, order_by: [desc: r.inserted_at])
    |> Repo.all()
  end
end

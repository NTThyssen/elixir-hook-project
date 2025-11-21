defmodule WebhookBucket.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :headers, :map
      add :body, :map
      add :method, :string
      add :bucket_id, references(:buckets, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:requests, [:bucket_id])
  end
end

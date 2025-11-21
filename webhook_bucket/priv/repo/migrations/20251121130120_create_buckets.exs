defmodule WebhookBucket.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :user_id, :string
      add :unique_slug, :string
      add :target_url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:buckets, [:unique_slug])
  end
end

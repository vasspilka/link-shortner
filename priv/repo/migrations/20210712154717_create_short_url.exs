defmodule Short.Repo.Migrations.CreateShortUrl do
  use Ecto.Migration

  def change do
    create table(:short_url, primary_key: false) do
      add :slug, :string, primary_key: true
      add :url, :string
    end
  end
end

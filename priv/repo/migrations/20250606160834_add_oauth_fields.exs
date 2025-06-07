defmodule Budgetd.Repo.Migrations.AddOauthFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_oauth_user, :boolean, default: false
      add :provider, :string
      modify :hashed_password, :string, null: true
    end
  end
end

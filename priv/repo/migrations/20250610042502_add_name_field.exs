defmodule Budgetd.Repo.Migrations.AddNameField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end
  end
end

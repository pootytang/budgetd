defmodule Budgetd.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :category, :string, null: false
      add :description, :string
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:budgets, [:user_id])

    create constraint(
             :budgets,
             :budget_end_after_start,
             check: "end_date > start_date",
             comment: "End date must be after start date"
           )
  end
end

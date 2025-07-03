defmodule Budgetd.Repo.Migrations.CreateBudgetPeriods do
  use Ecto.Migration

  def change do
    create table(:budget_periods, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_date, :date
      add :end_date, :date
      add :budget_id, references(:budgets, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:budget_periods, [:user_id])

    create index(:budget_periods, [:budget_id])
  end
end

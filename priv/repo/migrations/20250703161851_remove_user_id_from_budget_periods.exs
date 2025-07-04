defmodule Budgetd.Repo.Migrations.RemoveUserIdFromBudgetPeriods do
  use Ecto.Migration

  def change do
    alter table(:budget_periods) do
      remove :user_id
    end
  end
end

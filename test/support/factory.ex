defmodule Budgetd.Factory do
  use ExMachina.Ecto, repo: Budgetd.Repo

  alias Budgetd.Auth
  alias Budgetd.Mimo

  def without_preloads(objects) when is_list(objects), do: Enum.map(objects, &without_preloads/1)
  def without_preloads(%Mimo.Budget{} = budget), do: Ecto.reset_fields(budget, [:user])

  def without_preloads(%Mimo.BudgetTransaction{} = transaction),
    do: Ecto.reset_fields(transaction, [:budget])

  def user_factory do
    %Auth.User{
      name: sequence(:user_name, &"Christian Alexander #{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: "_"
    }
  end

  def budget_factory do
    %Mimo.Budget{
      name: sequence(:budget_name, &"Budget #{&1}"),
      category: sequence(:category, ["travel", "equipment", "service", "other"]),
      description: sequence(:budget_description, &"BUDGET DESCRIPTION #{&1}"),
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-12-31],
      user: build(:user)
    }
  end

  def budget_period_factory do
    %Mimo.BudgetPeriod{
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-12-31],
      budget: build(:budget)
    }
  end

  def budget_transaction_factory do
    %Mimo.BudgetTransaction{
      effective_date: ~D[2025-01-01],
      amount: Decimal.new("123.45"),
      description: sequence(:transaction_description, &"TRANSACTION DESCRIPTION #{&1}"),
      budget: build(:budget),
      type: :money_out
    }
  end
end

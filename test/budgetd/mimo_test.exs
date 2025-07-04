defmodule Budgetd.MimoTest do
  use Budgetd.DataCase

  import Budgetd.MimoFixtures

  alias Budgetd.Mimo

  describe "budgets" do
    alias Budgetd.Mimo.Budget

    test "create_budget/1 with valid data creates budget" do
      attrs = params_with_assocs(:budget)

      assert {:ok, %Budget{} = budget} = Mimo.create_budget(attrs)
      assert budget.name == attrs.name
      assert budget.category == attrs.category
      assert budget.description == attrs.description
      assert budget.start_date == attrs.start_date
      assert budget.end_date == attrs.end_date
      assert budget.user_id == attrs.user_id
    end
  end

  test "create_budget/2 requires name" do
    attrs =
      valid_budget_attributes()
      |> Map.delete(:name)

    assert {:error, %Ecto.Changeset{} = changeset} = Mimo.create_budget(attrs)

    assert changeset.valid? == false
    assert %{name: ["can't be blank"]} = errors_on(changeset)
  end

  test "create_budget/2 requires valid dates" do
    attrs =
      valid_budget_attributes()
      |> Map.merge(%{
        start_date: ~D[2025-12-01],
        end_date: ~D[2025-01-31]
      })

    assert {:error, %Ecto.Changeset{} = changeset} = Mimo.create_budget(attrs)
    assert changeset.valid? == false
    assert %{end_date: ["End date must be after start date"]} = errors_on(changeset)
  end

  test "list_budgets/0 returns all budgets" do
    budgets = insert_pair(:budget)
    assert Mimo.list_budgets() == without_preloads(budgets)
  end

  test "list_transactions/1 returns all transactions in the budget, by reference" do
    budget = insert(:budget)

    transactions = insert_pair(:budget_transaction, budget: budget)
    _other_transactions = insert_pair(:budget_transaction)

    assert Mimo.list_transactions(budget) == without_preloads(transactions)
  end

  test "list_transactions/2 returns transactions with preloads" do
    budget = insert(:budget)

    transactions = insert_pair(:budget_transaction, budget: budget)

    assert Mimo.list_transactions(budget, preload: [budget: :user]) == transactions
  end
end

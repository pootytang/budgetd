defmodule Budgetd.MimoTest do
  use Budgetd.DataCase

  import Budgetd.MimoFixtures

  alias Budgetd.Mimo

  describe "budgets" do
    alias Budgetd.Mimo.Budget

    test "create_budget/1 with valid data creates budget" do
      user = Budgetd.AuthFixtures.user_fixture()

      attrs = valid_budget_attributes(%{user_id: user.id})

      assert {:ok, %Budget{} = budget} = Mimo.create_budget(attrs)
      assert budget.name == attrs.name
      assert budget.category == attrs.category
      assert budget.description == attrs.description
      assert budget.start_date == attrs.start_date
      assert budget.end_date == attrs.end_date
      assert budget.user_id == user.id
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
        start_date: ~D[2025-12-31],
        end_date: ~D[2025-01-01]
      })

    assert {:error, %Ecto.Changeset{} = changeset} = Mimo.create_budget(attrs)
    assert changeset.valid? == false
    assert %{end_date: ["End date must be after start date"]} = errors_on(changeset)
  end

  test "list_budgets/0 returns all budgets" do
    budget = Budgetd.MimoFixtures.budget_fixture()
    assert Mimo.list_budgets() == [budget]
  end
end

defmodule Budgetd.Mimo do
  import Ecto.Query, warn: false
  alias Budgetd.Repo
  alias Budgetd.Mimo.Budget

  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  def list_budgets, do: Repo.all(Budget)
  def get_budget(id), do: Repo.get(Budget, id)

  def change_budget(budget, attrs \\ %{}) do
    Budget.changeset(budget, attrs)
  end
end

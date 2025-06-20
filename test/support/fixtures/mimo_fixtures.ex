defmodule Budgetd.MimoFixtures do
  def valid_budget_attributes(attrs \\ %{}) do
    attrs
    |> add_user_if_necessary()
    |> Enum.into(%{
      name: "Test Budget",
      category: "Test Category",
      description: "Test Happy Path",
      start_date: ~D[2025-01-01],
      end_date: ~D[2025-01-31]
    })
  end

  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> valid_budget_attributes()
      |> Budgetd.Mimo.create_budget()

    budget
  end

  defp add_user_if_necessary(attrs) do
    Map.put_new_lazy(attrs, :user_id, fn ->
      Budgetd.AuthFixtures.user_fixture().id
    end)
  end
end

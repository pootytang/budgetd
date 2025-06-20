defmodule BudgetdWeb.BudgetLive.CreateDialog do
  use BudgetdWeb, :live_component
  alias Budgetd.Mimo
  alias Budgetd.Mimo.Budget

  @impl true
  def update(assigns, socket) do
    changeset = Mimo.change_budget(%Budget{})

    # convert the changeset to a form and assign it to the socket
    socket =
      socket
      |> assign(assigns)
      |> assign(form: to_form(changeset))

    {:ok, socket}
  end

  # Can define a render function OR a heex file with the same name _html.heex
end

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

  @impl true
  def handle_event("validate", %{"budget" => params}, socket) do
    changeset =
      Mimo.change_budget(%Budget{}, params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"budget" => params}, socket) do
    params = Map.put(params, "user_id", socket.assigns.current_user.id)

    with {:ok, %Budget{}} <- Mimo.create_budget(params) do
      socket =
        socket
        |> put_flash(:info, "Budget created successfully.")
        |> push_navigate(to: ~p"/budgets", replace: true)

      {:noreply, socket}
    else
      {:error, changeset} -> {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # Can define a render function OR a heex file with the same name _html.heex
end

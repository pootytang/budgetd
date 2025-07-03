defmodule BudgetdWeb.BudgetLive.TransactionDialog do
  use BudgetdWeb, :live_component
  alias Budgetd.Mimo
  # alias Budgetd.Mimo.BudgetTransaction

  @impl true
  def update(assigns, socket) do
    changeset = Mimo.change_transaction(assigns.transaction, %{})

    # convert the changeset to a form and assign it to the socket
    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Mimo.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  # Can define a render function OR a heex file with the same name _html.heex

  defp save_transaction(socket, :new_transaction, transaction_params) do
    budget = socket.assigns.budget

    transaction_params =
      Map.put(transaction_params, "budget_id", budget.id)

    case Mimo.create_transaction(transaction_params) do
      {:ok, _transaction} ->
        socket =
          socket
          |> put_flash(:info, "Transaction created")
          |> push_navigate(to: ~p"/budgets/#{budget}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp save_transaction(socket, :edit_transaction, transaction_params) do
    budget = socket.assigns.budget

    transaction_params =
      Map.put(transaction_params, "budget_id", budget.id)

    case Mimo.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, _transaction} ->
        socket =
          socket
          |> put_flash(:info, "Transaction updated")
          |> push_navigate(to: ~p"/budgets/#{budget}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: "transaction"))
  end

  # defp default_transaction do
  #   %BudgetTransaction{
  #     effective_date: Date.utc_today()
  #   }
  # end
end

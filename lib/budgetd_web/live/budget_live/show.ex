defmodule BudgetdWeb.BudgetLive.Show do
  alias Budgetd.Mimo.BudgetTransaction
  use BudgetdWeb, :live_view

  alias Budgetd.Mimo

  def mount(%{"budget_id" => id} = params, _session, socket) when is_uuid(id) do
    budget =
      Mimo.get_budget(id, user: socket.assigns.current_scope.user, preload: [:user, :periods])

    if budget do
      transactions = Mimo.list_transactions(budget)
      summary = Mimo.summarize_budget_transactions(budget)

      {:ok,
       assign(socket, budget: budget, transactions: transactions, summary: summary)
       |> apply_action(params)}
    else
      socket =
        socket
        |> put_flash(:error, "Budget not found")
        |> redirect(to: ~p"/budgets")

      {:ok, socket}
    end
  end

  def mount(_invalid_id, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "Budget not found")
      |> redirect(to: ~p"/budgets")

    {:ok, socket}
  end

  def apply_action(%{assigns: %{live_action: :edit_transaction}} = socket, %{
        "transaction_id" => transaction_id
      }) do
    transaction = Enum.find(socket.assigns.transactions, &(&1.id == transaction_id))

    if transaction do
      assign(socket, transaction: transaction)
    else
      socket
      |> put_flash(:error, "Transaction not found")
      |> redirect(to: ~p"/budgets/#{socket.assigns.budget}")
    end
  end

  def apply_action(socket, _params), do: socket

  def handle_event("delete_transaction", %{"id" => transaction_id}, socket) do
    transaction = Enum.find(socket.assigns.transactions, &(&1.id == transaction_id))

    if transaction do
      case Mimo.delete_transaction(transaction) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Transaction deleted")
            |> assign(transactions: Mimo.list_transactions(socket.assigns.budget))

          {:noreply, socket}

        {:error, _reason} ->
          {:noreply, put_flash(socket, :error, "Failed to delete transaction")}
      end
    else
      {:noreply, put_flash(socket, :error, "Transaction not found")}
    end
  end

  @doc """
    Renders a transaction amount as a currency value, considering the type of the transaction.
    ## Example
    <.transaction_amount transaction={%BudgetTransaction{type: :spending, amount: Decimal.new("24.05")}} />
    Output:
    <span class="tabular-nums text-red-500">-24.05</span>
  """
  attr :transaction, BudgetTransaction, required: true

  def transaction_amount(%{transaction: %{type: :money_out, amount: amount}}),
    do: currency(%{amount: Decimal.negate(amount)})

  def transaction_amount(%{transaction: %{type: :money_in, amount: amount}}),
    do: currency(%{amount: amount})

  @doc """
    Renders a currency amount field.
    ## Example
    <.currency amount={Decimal.new("246.01")} />
    Output:
    <span class="tabular-nums text-green-500">246.01</span>
  """
  attr :amount, Decimal, required: true
  attr :class, :string, default: nil
  attr :positive_class, :string, default: "text-green-500"
  attr :negative_class, :string, default: "text-red-500"

  def currency(assigns) do
    ~H"""
    <span class={[
      "tabular-nums",
      Decimal.gte?(@amount, 0) && @positive_class,
      Decimal.lt?(@amount, 0) && @negative_class,
      @class
    ]}>
      {Decimal.round(@amount, 2)}
    </span>
    """
  end

  defp default_transaction do
    %BudgetTransaction{
      effective_date: Date.utc_today()
    }
  end
end

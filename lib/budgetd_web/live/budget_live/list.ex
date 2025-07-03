defmodule BudgetdWeb.BudgetLive.List do
  use BudgetdWeb, :live_view

  alias Budgetd.Mimo

  def mount(_params, _session, socket) do
    budgets =
      Mimo.list_budgets(
        user: socket.assigns.current_scope.user,
        preload: :user
      )

    socket = assign(socket, budgets: budgets)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.show_modal
      :if={@live_action == :new}
      id="create-budget-modal"
      on_cancel={JS.navigate(~p"/budgets", replace: true)}
      onclose={JS.navigate(~p"/budgets", replace: true)}
    >
      <:form_component>
        <.live_component
          module={BudgetdWeb.BudgetLive.CreateDialog}
          id="create-budget"
          current_user={@current_scope.user}
        />
      </:form_component>
    </.show_modal>

    <div class="flex justify-end mt-8">
      <.link navigate={~p"/budgets/new"} class="btn btn-soft btn-primary rounded-lg">
        <.icon name="hero-plus" class="h-5 w-5" />
        <span>New Budget</span>
      </.link>
    </div>

    <.table id="budgets" rows={@budgets}>
      <:col :let={budget} label="Name">{budget.name}</:col>
      <:col :let={budget} label="Category">{budget.category}</:col>
      <:col :let={budget} label="Description">{budget.description}</:col>
      <:col :let={budget} label="Start Date">{budget.start_date}</:col>
      <:col :let={budget} label="End Date">{budget.end_date}</:col>
      <:col :let={budget} label="User Name">{budget.user.name}</:col>
      <:col :let={budget} label="Actions"><.link navigate={~p"/budgets/#{budget}"}>View</.link></:col>
    </.table>
    """
  end
end

defmodule BudgetdWeb.BudgetLive.List do
  use BudgetdWeb, :live_view

  alias Budgetd.Mimo

  def mount(_params, _session, socket) do
    budgets =
      Mimo.list_budgets()
      |> Budgetd.Repo.preload(:user)

    socket = assign(socket, budgets: budgets)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <dialog
      :if={@live_action == :new}
      id="create-budget-modal"
      title="Create Budget"
      on_cancel={JS.navigate(~p"/budgets", replace: true)}
      class="modal modal-open"
    >
      <div class="modal-box">
        <form method="dialog" class="modal-backdrop">
          <button
            class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2"
            onclick={JS.navigate(~p"/budgets", replace: true)}
          >
            ✕
          </button>
        </form>
        <.live_component
          module={BudgetdWeb.BudgetLive.CreateDialog}
          id="create-budget"
          current_user={@current_scope}
        />
      </div>
    </dialog>
    <div class="flex justify-end">
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
    </.table>
    """
  end
end

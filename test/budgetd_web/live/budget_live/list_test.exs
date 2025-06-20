defmodule BudgetdWeb.BudgetLive.ListTest do
  use BudgetdWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgetd.MimoFixtures

  setup do
    user = Budgetd.AuthFixtures.user_fixture()

    %{user: user}
  end

  describe "Index view" do
    # conn is created by ConnCase and user created by setup
    test "shows budget when one exists", %{conn: conn, user: user} do
      budget = budget_fixture(%{user_id: user.id})

      conn = log_in_user(conn, user)
      # live returns an ok tuple, a reference to the live view process and the rendered HTML
      {:ok, lv, html} = live(conn, ~p"/budgets")

      open_browser(lv)

      assert html =~ budget.name
      assert html =~ budget.category
      assert html =~ budget.description
    end
  end
end

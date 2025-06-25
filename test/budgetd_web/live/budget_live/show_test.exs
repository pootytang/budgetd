defmodule BudgetdWeb.BudgetLive.ShowTest do
  use BudgetdWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Budgetd.MimoFixtures

  setup do
    user = Budgetd.AuthFixtures.user_fixture()
    budget = budget_fixture(%{user_id: user.id})

    %{user: user, budget: budget}
  end

  describe "Show Budget" do
    test "shows budget when it exists", %{conn: conn, user: user, budget: budget} do
      conn = log_in_user(conn, user)

      {:ok, _lv, html} = live(conn, ~p"/budgets/#{budget}")

      assert html =~ budget.name
    end

    test "redirectes to budget list page when budget does not exist", %{conn: conn, user: user} do
      fake_budget_id = Ecto.UUID.generate()

      conn = log_in_user(conn, user)

      {:ok, conn} =
        live(conn, ~p"/budgets/#{fake_budget_id}")
        |> follow_redirect(conn, ~p"/budgets")

      assert %{"error" => "Budget not found"} = conn.assigns.flash
    end

    test "redirects to budget list page when budget is hidden from the user", %{
      conn: conn,
      budget: budget
    } do
      other_user = Budgetd.AuthFixtures.user_fixture()

      conn = log_in_user(conn, other_user)

      {:ok, conn} =
        live(conn, ~p"/budgets/#{budget}")
        |> follow_redirect(conn, ~p"/budgets")

      assert %{"error" => "Budget not found"} = conn.assigns.flash
    end
  end
end

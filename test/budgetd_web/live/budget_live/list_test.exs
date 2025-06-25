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
      {:ok, _lv, html} = live(conn, ~p"/budgets")

      # open_browser(lv)

      assert html =~ budget.name
      assert html =~ budget.category
      assert html =~ budget.description
    end
  end

  describe "Create budget modal" do
    test "modal is presented", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      assert has_element?(lv, "#create-budget-modal")
    end

    # TODO: The next two tests fail with a warning "warning: Duplicate id found while testing LiveView:..."
    # test "validatation errors are presented when form is changed with invalid input", %{
    #   conn: conn,
    #   user: user
    # } do
    #   conn = log_in_user(conn, user)
    #   {:ok, lv, _html} = live(conn, ~p"/budgets/new")

    #   form = element(lv, "#create-budget-modal form")

    #   html = render_change(form, %{"budget" => %{"name" => ""}})

    #   assert html =~ html_escape("can't be blank")
    # end

    # test "creates a budget", %{conn: conn, user: user} do
    #   {:ok, lv, _html} = live(conn, ~p"/budgets/new")

    #   form = form(lv, "#create-budget-modal form")

    #   {:ok, _lv, html} =
    #     render_submit(form, %{
    #       "budget" => %{
    #         "name" => "A New Name",
    #         "category" => "Test Category",
    #         "description" => "The new description",
    #         "start_date" => "2025-01-01",
    #         "end_date" => "2025-01-31"
    #       }
    #     })
    #     |> follow_redirect(conn)

    #   assert html =~ "Budget created successfully"
    #   assert html =~ "A New Name"
    #   assert html =~ "Test Category"

    #   assert [created_budget] = Budgetd.Mimo.list_budgets()
    #   assert created_budget.name == "A New Name"
    #   assert created_budget.category == "Test Category"
    #   assert created_budget.description == "The new description"
    #   assert created_budget.start_date == ~D[2025-01-01]
    #   assert created_budget.end_date == ~D[2025-01-31]
    # end
  end
end

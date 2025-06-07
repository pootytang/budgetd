defmodule BudgetdWeb.PageController do
  use BudgetdWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

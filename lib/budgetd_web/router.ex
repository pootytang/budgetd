defmodule BudgetdWeb.Router do
  use BudgetdWeb, :router
  require Logger

  import BudgetdWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BudgetdWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  # pipeline :redirect_if_user_is_authenticated do
  #   plug :redirect_if_user_is_authenticated
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BudgetdWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BudgetdWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:budgetd, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BudgetdWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BudgetdWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BudgetdWeb.UserAuth, :require_authenticated}] do
      live "/budgets", BudgetLive.List
      live "/budgets/new", BudgetLive.List, :new
      live "/budgets/:budget_id", BudgetLive.Show
      live "/budgets/:budget_id/new-transaction", BudgetLive.Show, :new_transaction

      live "/budgets/:budget_id/transactions/:transaction_id/edit",
           BudgetLive.Show,
           :edit_transaction

      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", BudgetdWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{BudgetdWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :login
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  scope "/auth", BudgetdWeb do
    pipe_through [:browser]
    # Handled by Ueberauth
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end

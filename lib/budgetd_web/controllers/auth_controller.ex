defmodule BudgetdWeb.AuthController do
  require Logger

  alias BudgetdWeb.UserAuth
  alias Budgetd.Auth

  use BudgetdWeb, :controller

  plug Ueberauth

  # def request(conn, params) do
  #   Logger.info("Request called with params: #{inspect(params)}")

  #   Phoenix.Controller.redirect(conn, to: Ueberauth.Strategy.Helpers.callback_url(conn))
  # end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    Logger.info("Callback called with params: #{inspect(params)}")

    email = auth.info.email
    Logger.info("Authentication callback received for email: #{email}")

    case Auth.get_user_by_email(email) do
      nil ->
        # User does not exist, create a new user
        Logger.info("No user found for email: #{email}, creating new user.")

        user_params = %{
          email: email,
          name: auth.info.name || "Unknown User",
          provider: auth.provider,
          uid: auth.uid
        }

        case Auth.register_oauth_user(user_params) do
          {:ok, user} ->
            Logger.info("New user created for email: #{email}, logging in.")
            UserAuth.log_in_user(conn, user)

          {:error, changeset} ->
            Logger.error(
              "Failed to create user for email: #{email}, changeset: #{inspect(changeset)}"
            )

            conn
            |> put_flash(:error, "Failed to create user account.")
            |> redirect(to: "/")
        end

      user ->
        Logger.info("User found for email: #{email}, logging in.")
        UserAuth.log_in_user(conn, user)
    end

    # Copilot generated code
    # case Auth.get_user_by_email(email) do
    #   nil -> # User does not exist, create a new user
    #     Logger.info("No user found for email: #{email}, creating new user.")
    #     case Auth.register_oauth_user(%{email: email, name: auth.info.name || "Unknown User", provider: auth.provider, uid: auth.uid}) do
    #       {:ok, user} ->
    #         Logger.info("New user created for email: #{email}, logging in.")
    #         UserAuth.log_in_user(conn, user)
    #       {:error, changeset} ->
    #         Logger.error("Failed to create user for email: #{email}, changeset: #{inspect(changeset)}")
    #         conn
    #         |> put_flash(:error, "Failed to create user account.")
    #         |> redirect(to: "/")
    #
    #       end
    #     UserAuth.log_in_user(conn, user)

    #   user ->
    #     Logger.info("User found for email: #{email}, logging in.")
    #     UserAuth.log_in_user(conn, user)
    # end
  end
end

defmodule Budgetd.Repo do
  use Ecto.Repo,
    otp_app: :budgetd,
    adapter: Ecto.Adapters.Postgres
end

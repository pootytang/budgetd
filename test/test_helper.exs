ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Budgetd.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)

defmodule Budgetd.Mimo.BudgetPeriod do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "budget_periods" do
    field :start_date, :date
    field :end_date, :date
    field :budget_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_period, attrs, user_scope) do
    budget_period
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
    |> put_change(:user_id, user_scope.user.id)
  end
end

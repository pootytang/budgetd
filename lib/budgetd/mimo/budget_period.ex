defmodule Budgetd.Mimo.BudgetPeriod do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "budget_periods" do
    field :start_date, :date
    field :end_date, :date
    belongs_to :budget, Budgetd.Mimo.Budget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_period, attrs) do
    budget_period
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
    |> check_constraint(:end_date,
      name: :end_after_start,
      message: "must end after its start date"
    )
    |> unique_constraint([:budget_id, :start_date])
    |> Budgetd.Validations.validate_date_month_boundaries()
  end
end

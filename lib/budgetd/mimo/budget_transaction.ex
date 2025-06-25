defmodule Budgetd.Mimo.BudgetTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "budget_transactions" do
    field :effective_date, :date
    field :type, Ecto.Enum, values: [:money_in, :money_out]
    field :category, Ecto.Enum, values: [:travel, :equipment, :service, :other]
    field :amount, :decimal
    field :description, :string

    belongs_to :budget, Budgetd.Mimo.Budget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_transaction, attrs) do
    budget_transaction
    |> cast(attrs, [:effective_date, :type, :category, :amount, :description, :budget_id])
    |> validate_required([:effective_date, :type, :category, :amount, :description, :budget_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end
end

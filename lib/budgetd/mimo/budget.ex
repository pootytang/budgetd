defmodule Budgetd.Mimo.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "budgets" do
    field :name, :string
    field :category, :string
    field :description, :string
    field :start_date, :date
    field :end_date, :date

    belongs_to :user, Budgetd.Auth.User

    timestamps(type: :utc_datetime)
  end

  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:name, :category, :description, :start_date, :end_date, :user_id])
    |> validate_required([:name, :category, :start_date, :end_date, :user_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:category, min: 2, max: 100)
    |> validate_length(:description, max: 500)
    |> check_constraint(:end_date,
      name: :budget_end_after_start,
      message: "End date must be after start date"
    )
  end
end

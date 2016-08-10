defmodule Recurly.Plan do
  @moduledoc """
  Module for handling plans in Recurly.
  See the [developer docs on plans](https://dev.recurly.com/docs/list-plans)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "/plans"

  schema :plan do
    field :accounting_code
    field :cancel_url
    field :display_quantity, :boolean
    field :name
    field :plan_code
    field :plan_interval_unit
    field :plan_interval_length, :integer
    field :revenue_schedule_type
    field :setup_fee_accounting_code
    field :setup_fee_in_cents, Recurly.Money
    field :setup_fee_revenue_schedule_type
    field :success_url
    field :total_billing_cycles
    field :trial_interval_unit
    field :trial_interval_length, :integer
    field :unit_amount_in_cents, Recurly.Money
    field :unit_name
    field :tax_code
    field :tax_exempt, :boolean
  end

  @doc """
  Finds a plan given a plan code. Returns the plan or an error.

  ## Parameters

  - `plan_code` String plan code

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Plan.find("myplancode") do
    {:ok, plan} ->
      # Found the plan
    {:error, %NotFoundError{}} ->
      # 404 plan was not found
  end
  ```
  """
  def find(plan_code) do
    Resource.find(%Recurly.Plan{}, path(plan_code))
  end

  @doc """
  Creates a plan from a changeset.

  ## Parameters

  - `changeset` Keyword list changeset

  ## Examples

  ```
  alias Recurly.ValidationError

  changeset = [
    plan_code: "gold",
    name: "Gold",
    plan_interval_length: 1,
    plan_interval_unit: "month",
    unit_amount_in_cents: [
      USD: 200,
      EUR: 300
    ]
  ]

  case Recurly.Plan.create(changeset) do
    {:ok, plan} ->
      # created the plan
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset) do
    Resource.create(%Recurly.Plan{}, changeset, @endpoint)
  end

  @doc """
  Generates the path to a plan given the plan code

  ## Parameters

    - `plan_code` String plan code

  """
  def path(plan_code) do
    Path.join(@endpoint, plan_code)
  end
end

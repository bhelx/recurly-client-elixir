defmodule Recurly.AddOn do
  @moduledoc """
  Module for handling plan addons in Recurly.
  See the [developer docs on plan addons](https://dev.recurly.com/docs/plan-add-ons-object)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource,AddOn}

  @endpoint "plans/<%= plan_code %>/add_ons"

  @type t :: %__MODULE__{
    accounting_code:                 String.t,
    add_on_code:                     String.t,
    add_on_type:                     String.t,
    default_quantity:                integer,
    display_quantity_on_hosted_page: boolean,
    measured_unit_id:                String.t,
    name:                            String.t,
    optional:                        boolean,
    revenue_schedule_type:           String.t,
    tax_code:                        String.t,
    unit_amount_in_cents:            Recurly.Money,
    usage_percentage:                String.t,
    usage_type:                      String.t,
  }

  schema :add_on do
    field :accounting_code,                 :string
    field :add_on_code,                     :string
    field :add_on_type,                     :string
    field :default_quantity,                :integer
    field :display_quantity_on_hosted_page, :boolean
    field :measured_unit_id,                :string
    field :name,                            :string
    field :optional,                        :boolean
    field :revenue_schedule_type,           :string
    field :tax_code,                        :string
    field :unit_amount_in_cents,            Recurly.Money
    field :usage_percentage,                :string
    field :usage_type,                      :string
  end

  @doc """
  Creates plan addon from a changeset.

  ## Parameters

  - `changeset` Keyword list changeset. This must include a `plan_code` key.
  - `plan_code` String plan code of parent plan

  ## Examples

  ```
  alias Recurly.ValidationError

  changeset = [
    plan_code: "gold",
    add_on_code: "ipaddresses",
    name: "Extra IP Addresses",
    unit_amount_in_cents: [
      USD: 200
    ]
  ]

  case Recurly.AddOn.create(changeset) do
    {:ok, addon} ->
      # created the addon
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  @spec create(keyword) :: {:ok, AddOn.t} | {:error, any}
  def create(changeset) do
    plan_code = Keyword.fetch!(changeset, :plan_code)
    Resource.create(%AddOn{}, changeset, path(plan_code))
  end

  @doc """
  Generates the path to an addon given the plan code.

  ## Parameters

    - `plan_code` String plan code

  """
  @spec path(String.t) :: String.t
  def path(plan_code) do
    EEx.eval_string(@endpoint, plan_code: plan_code)
  end
end

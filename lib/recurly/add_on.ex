defmodule Recurly.AddOn do
  @moduledoc """
  Module for handling plan addons in Recurly.
  See the [developer docs on plan addons](https://dev.recurly.com/docs/plan-add-ons-object)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "plans/<%= plan_code %>/add_ons"

  schema :add_on do
    field :add_on_code
    field :name
    field :unit_amount_in_cents, Recurly.Money
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
  def create(changeset) do
    plan_code = Keyword.fetch!(changeset, :plan_code)
    Resource.create(%Recurly.AddOn{}, changeset, path(plan_code))
  end

  @doc """
  Generates the path to an addon given the plan code.

  ## Parameters

    - `plan_code` String plan code

  """
  def path(plan_code) do
    EEx.eval_string(@endpoint, plan_code: plan_code)
  end
end

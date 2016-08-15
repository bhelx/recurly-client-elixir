defmodule Recurly.Adjustment do
  @moduledoc """
  Module for handling adjustments in Recurly.
  See the [developer docs on adjustments](https://dev.recurly.com/docs/adjustment-object)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "accounts/<%= account_code %>/adjustments"

  schema :adjustment do
    field :accounting_code,       :string
    field :currency,              :string
    field :description,           :string
    field :end_date,              :date_time
    field :quantity,              :integer
    field :revenue_schedule_type, :string
    field :start_date,            :date_time
    field :tax_code,              :boolean
    field :tax_exempt,            :string
    field :unit_amount_in_cents,  :integer
  end

  @doc """
  Creates an adjustment from a changeset.

  ## Parameters

  - `changeset` Keyword list changeset
  - `account_code` String account code of associated account

  ## Examples

  ```
  alias Recurly.ValidationError

  case Recurly.Adjustment.create([unit_amount_in_cents: 100, currency: "USD"], "myaccountcode") do
    {:ok, adjustment} ->
      # created the adjustment
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset, account_code) do
    Resource.create(%Recurly.Adjustment{}, changeset, path(account_code))
  end

  @doc """
  Generates the path to an adjustment given the account code.

  ## Parameters

    - `account_code` String account code

  """
  def path(account_code) do
    EEx.eval_string(@endpoint, account_code: account_code)
  end
end

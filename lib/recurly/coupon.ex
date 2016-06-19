defmodule Recurly.Coupon do
  @moduledoc """
  Module for handling coupons in Recurly.
  See the [developer docs on coupons](https://dev.recurly.com/docs/list-active-coupons)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "/coupons"

  schema :coupon do
    field :coupon_code
    field :name
    field :discount_type
    field :discount_in_cents, Recurly.Money
    field :discount_percent, :integer
    field :invoice_description
    field :single_use, :boolean
    field :applies_for_months, :integer
    field :applies_to_all_plans, :boolean
    field :max_redemptions, :integer
    field :duration
    field :temporal_unit
    field :temporal_amount, :integer
    field :applies_to_non_plan_charges, :boolean
    field :redemption_resource
    field :max_redemptions_per_account, :integer
    field :coupon_type
    field :unique_code_template
    #field :plan_codes
  end

  @doc """
  Lists all the coupons. See [the couopons dev docs](https://dev.recurly.com/docs/list-active-coupons) for more details.

  ## Parameters

  - `options` Keyword list of GET params

  ## Examples

  ```
  case Recurly.Coupon.list(state: "redeemable") do
    {:ok, coupons} ->
      # list of redeemable coupons
    {:error, error} ->
      # error happened
  end
  ```
  """
  def list(options \\ []) do
    Resource.list(%Recurly.Coupon{}, @endpoint, options)
  end

  @doc """
  Finds a coupon given a coupon code. Returns the coupon or an error.

  ## Parameters

  - `coupon_code` String coupon code

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Coupon.find("mycouponcode") do
    {:ok, coupon} ->
      # Found the coupon
    {:error, %NotFoundError{}} ->
      # 404 coupon was not found
  end
  ```
  """
  def find(coupon_code) do
    Resource.find(%Recurly.Coupon{}, path(coupon_code))
  end

  @doc """
  Creates a coupon from a changeset.

  ## Parameters

  - `changeset` Keyword list changeset

  ## Examples

  ```
  alias Recurly.ValidationError

  changeset = [
    coupon_code: "mycouponcode",
    name: "My Coupon",
    discount_type: "dollars",
    discount_in_cents: [
      USD: 1000
    ],
    duration: "single_use"
  ]

  case Recurly.Coupon.create(changeset) do
    {:ok, coupon} ->
      # created the coupon
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset) do
    Resource.create(%Recurly.Coupon{}, changeset, @endpoint)
  end

  @doc """
  Generates the path to a coupon given the coupon code

  ## Parameters

    - `coupon_code` String coupon code

  """
  def path(coupon_code) do
    Path.join(@endpoint, coupon_code)
  end
end

defmodule Recurly.Coupon do
  @moduledoc """
  Module for handling coupons in Recurly.
  See the [developer docs on coupons](https://dev.recurly.com/docs/list-active-coupons)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource,Coupon,Money}

  @endpoint "/coupons"

  schema :coupon do
    field :applies_to_all_plans,        :boolean
    field :applies_to_non_plan_charges, :boolean
    field :coupon_code,                 :string
    field :coupon_type,                 :string
    field :created_at,                  :date_time, read_only: true
    field :deleted_at,                  :date_time, read_only: true
    field :description,                 :string
    field :discount_type,               :string
    field :discount_in_cents,           Money
    field :discount_percent,            :integer
    field :duration,                    :string
    field :invoice_description,         :string
    field :max_redemptions,             :integer
    field :max_redemptions_per_account, :integer
    field :name,                        :string
    field :plan_codes,                  list: true
    field :redeem_by_date,              :date_time
    field :redemption_resource,         :string
    field :state,                       :string
    field :temporal_amount,             :integer
    field :temporal_unit,               :string
    field :unique_code_template,        :string
    field :updated_at,                  :date_time, read_only: true
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
    Resource.list(%Coupon{}, @endpoint, options)
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
    Resource.find(%Coupon{}, path(coupon_code))
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
    Resource.create(%Coupon{}, changeset, @endpoint)
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

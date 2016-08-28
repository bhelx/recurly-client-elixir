defmodule Recurly.Coupon do
  @moduledoc """
  Module for handling coupons in Recurly.
  See the [developer docs on coupons](https://dev.recurly.com/docs/list-active-coupons)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource,Coupon,Money}

  @endpoint "/coupons"

  @type t :: %__MODULE__{
    applies_to_all_plans:        boolean,
    applies_to_non_plan_charges: boolean,
    coupon_code:                 String.t,
    coupon_type:                 String.t,
    description:                 String.t,
    discount_type:               String.t,
    discount_in_cents:           Money.t,
    discount_percent:            integer,
    duration:                    String.t,
    invoice_description:         String.t,
    max_redemptions:             integer,
    max_redemptions_per_account: integer,
    name:                        String.t,
    plan_codes:                  list,
    redeem_by_date:              String.t,
    temporal_unit:               String.t,
    temporal_amount:             integer,
    redemption_resource:         String.t,
    unique_code_template:        String.t,
  }

  schema :coupon do
    field :applies_to_all_plans,        :boolean
    field :applies_to_non_plan_charges, :boolean
    field :coupon_code,                 :string
    field :coupon_type,                 :string
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
    field :redeem_by_date,              :string
    field :temporal_unit,               :string
    field :temporal_amount,             :integer
    field :redemption_resource,         :string
    field :unique_code_template,        :string
  end

  @doc """
  Creates a stream of coupons given some options.

  ## Parameters

  - `options` Keyword list of the request options. See options in the
      [coupon list section](https://dev.recurly.com/docs/list-active-coupons)
      of the docs.

  ## Examples

  See `Recurly.Resource.stream/3` for more detailed examples of
  working with resource streams.

  ```
  # stream of coupons sorted from most recently
  # updated to least recently updated
  stream = Recurly.Coupon.stream(sort: :updated_at)
  ```
  """
  @spec stream(keyword) :: Enumerable.t
  def stream(options \\ []) do
    Resource.stream(stream, @endpoint, options)
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
  @spec find(String.t) :: {:ok, Coupon.t} | {:error, any}
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
  @spec create(keyword) :: {:ok, Coupon.t} | {:error, any}
  def create(changeset) do
    Resource.create(%Coupon{}, changeset, @endpoint)
  end

  @doc """
  Generates the path to a coupon given the coupon code

  ## Parameters

    - `coupon_code` String coupon code

  """
  @spec path(String.t) :: String.t
  def path(coupon_code) do
    Path.join(@endpoint, coupon_code)
  end
end

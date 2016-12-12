defmodule Recurly.CouponTest do
  use ExUnit.Case, async: true
  alias Recurly.Coupon
  import Utils

  @readable_fields ~w(
    applies_to_all_plans
    applies_to_non_plan_charges
    coupon_code
    coupon_type
    created_at
    deleted_at
    description
    discount_type
    discount_in_cents
    discount_percent
    duration
    invoice_description
    max_redemptions
    max_redemptions_per_account
    name
    plan_codes
    redeem_by_date
    redemption_resource
    state
    temporal_amount
    temporal_unit
    unique_code_template
    updated_at
  )a

  @writeable_fields ~w(
    applies_to_all_plans
    applies_to_non_plan_charges
    coupon_code
    coupon_type
    description
    discount_type
    discount_in_cents
    discount_percent
    duration
    invoice_description
    max_redemptions
    max_redemptions_per_account
    name
    plan_codes
    redeem_by_date
    redemption_resource
    state
    temporal_amount
    temporal_unit
    unique_code_template
  )a

  test "should maintain the list of writeable fields" do
    compare_writeable_fields(Coupon, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(Coupon, @readable_fields)
  end

  test "Coupon#path should resolve to the coupons endpoint" do
    coupon_code = "my-coupon-code"
    assert Coupon.path(coupon_code) == "/coupons/#{coupon_code}"
  end
end

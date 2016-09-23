defmodule Recurly.CouponTest do
  use ExUnit.Case, async: true
  alias Recurly.Coupon
  import Utils

  @all_fields ~w(
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
    temporal_unit
    temporal_amount
    redemption_resource
    unique_code_template
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Coupon, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Coupon, @all_fields)
  end

  test "Coupon#path should resolve to the coupons endpoint" do
    coupon_code = "my-coupon-code"
    assert Coupon.path(coupon_code) == "/coupons/#{coupon_code}"
  end
end

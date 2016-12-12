defmodule Recurly.AdjustmentTest do
  use ExUnit.Case, async: true
  alias Recurly.Adjustment
  import Utils

  @readable_fields ~w(
    account
    accounting_code
    currency
    created_at
    description
    discount_in_cents
    end_date
    invoice
    origin
    original_adjustment_uuid
    product_code
    quantity
    quantity_remaining
    revenue_schedule_type
    state
    start_date
    subscription
    tax_code
    tax_exempt
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    taxable
    total_in_cents
    unit_amount_in_cents
    updated_at
    uuid
  )a

  @writeable_fields ~w(
    accounting_code
    currency
    description
    discount_in_cents
    end_date
    origin
    original_adjustment_uuid
    product_code
    quantity
    quantity_remaining
    revenue_schedule_type
    state
    start_date
    tax_code
    tax_exempt
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    taxable
    total_in_cents
    unit_amount_in_cents
    uuid
  )a

  test "should maintain the list of writeable fields" do
    compare_writeable_fields(Adjustment, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(Adjustment, @readable_fields)
  end

  test "Adjustment#find_path resolve to the adjustments endpoint" do
    uuid = "abcdef1234567890"
    assert Adjustment.find_path(uuid) == "/adjustments/#{uuid}"
  end
end

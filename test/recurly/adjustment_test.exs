defmodule Recurly.AdjustmentTest do
  use ExUnit.Case, async: true
  alias Recurly.Adjustment
  import Utils

  @all_fields ~w(
    accounting_code
    currency
    description
    end_date
    quantity
    revenue_schedule_type
    start_date
    tax_code
    tax_exempt
    unit_amount_in_cents
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Adjustment, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Adjustment, @all_fields)
  end

  test "Adjustment#find_path resolve to the adjustments endpoint" do
    uuid = "abcdef1234567890"
    assert Adjustment.find_path(uuid) == "/adjustments/#{uuid}"
  end

  test "Adjustment#account_path resolve to the account's adjustments endpoint" do
    account_code = "my-account-code"
    assert Adjustment.account_path(account_code) == "/accounts/#{account_code}/adjustments"
  end
end

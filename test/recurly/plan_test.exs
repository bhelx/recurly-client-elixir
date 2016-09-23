defmodule Recurly.PlanTest do
  use ExUnit.Case, async: true
  alias Recurly.Plan
  import Utils

  @all_fields ~w(
    accounting_code
    display_quantity
    description
    name
    plan_code
    plan_interval_length
    plan_interval_unit
    revenue_schedule_type
    setup_fee_accounting_code
    setup_fee_in_cents
    setup_fee_revenue_schedule_type
    success_url
    total_billing_cycles
    trial_interval_length
    trial_interval_unit
    unit_amount_in_cents
    tax_code
    tax_exempt
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Plan, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Plan, @all_fields)
  end

  test "Plan#path should resolve to the plans endpoint" do
    plan_code = "gold"
    assert Plan.path(plan_code) == "/plans/#{plan_code}"
  end
end

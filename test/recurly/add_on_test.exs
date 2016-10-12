defmodule Recurly.AddOnTest do
  use ExUnit.Case, async: true
  alias Recurly.AddOn
  import Utils

  @all_fields ~w(
    accounting_code
    add_on_code
    add_on_type
    default_quantity
    display_quantity_on_hosted_page
    measured_unit_id
    name
    optional
    revenue_schedule_type
    tax_code
    unit_amount_in_cents
    usage_percentage
    usage_type
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(AddOn, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(AddOn, @all_fields)
  end

  test "Account#path should resolve to the add_ons endpoint" do
    plan_code = "gold"
    assert AddOn.path(plan_code) == "/plans/#{plan_code}/add_ons"
  end
end

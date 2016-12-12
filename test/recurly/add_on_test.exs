defmodule Recurly.AddOnTest do
  use ExUnit.Case, async: true
  alias Recurly.AddOn
  import Utils

  @readable_fields ~w(
    accounting_code
    add_on_code
    add_on_type
    created_at
    default_quantity
    display_quantity_on_hosted_page
    measured_unit_id
    name
    optional
    plan
    revenue_schedule_type
    tax_code
    unit_amount_in_cents
    updated_at
    usage_percentage
    usage_type
  )a

  @writeable_fields ~w(
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
    compare_writeable_fields(AddOn, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(AddOn, @readable_fields)
  end

  test "Account#path should resolve to the add_ons endpoint" do
    plan_code = "gold"
    assert AddOn.path(plan_code) == "/plans/#{plan_code}/add_ons"
  end
end

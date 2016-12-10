defmodule Recurly.SubscriptionAddOnTest do
  use ExUnit.Case, async: true
  alias Recurly.SubscriptionAddOn
  import Utils

  @all_fields ~w(
    add_on_code
    quantity
    revenue_schedule_type
    unit_amount_in_cents
    usage_percentage
  )a

  test "should maintain the list of writeable fields" do
    compare_writeable_fields(SubscriptionAddOn, @all_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(SubscriptionAddOn, @all_fields)
  end
end

defmodule Recurly.SubscriptionTest do
  use ExUnit.Case, async: true
  alias Recurly.Subscription
  import Utils

  @readable_fields ~w(
    account
    activated_at
    canceled_at
    currency
    current_period_started_at
    expires_at
    bank_account_authorized_at
    bulk
    coupon_code
    collection_method
    customer_notes
    first_renewal_date
    net_terms
    plan
    plan_code
    po_number
    quantity
    state
    subscription_add_ons
    starts_at
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    terms_and_conditions
    total_billing_cycles
    trial_ends_at
    unit_amount_in_cents
    updated_at
    uuid
    vat_reverse_charge_notes
    revenue_schedule_type
  )a

  @writeable_fields ~w(
    account
    currency
    current_period_started_at
    bank_account_authorized_at
    bulk
    coupon_code
    collection_method
    customer_notes
    first_renewal_date
    net_terms
    plan
    plan_code
    po_number
    quantity
    subscription_add_ons
    starts_at
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    terms_and_conditions
    total_billing_cycles
    trial_ends_at
    unit_amount_in_cents
    uuid
    vat_reverse_charge_notes
    revenue_schedule_type
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Subscription, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Subscription, @readable_fields)
  end

  test "Subscription#path should resolve to the subscriptions endpoint" do
    uuid = "abcdef1234567890"
    assert Subscription.path(uuid) == "/subscriptions/#{uuid}"
  end
end

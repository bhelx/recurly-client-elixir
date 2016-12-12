defmodule Recurly.BillingInfoTest do
  use ExUnit.Case, async: true
  alias Recurly.BillingInfo
  import Utils

  @readable_fields ~w(
    account
    account_number
    account_type
    address1
    address2
    card_type
    city
    company
    country
    currency
    first_name
    first_six
    ip_address
    ip_address_country
    last_four
    last_name
    month
    name_on_account
    number
    paypal_billing_agreement_id
    phone
    routing_number
    state
    token_id
    vat_number
    verification_value
    year
    zip
  )a

  @writeable_fields ~w(
    account_number
    account_type
    address1
    address2
    card_type
    city
    company
    country
    currency
    first_name
    first_six
    ip_address
    ip_address_country
    last_four
    last_name
    month
    name_on_account
    number
    paypal_billing_agreement_id
    phone
    routing_number
    state
    token_id
    vat_number
    verification_value
    year
    zip
  )a

  test "should maintain the list of writeable fields" do
    compare_writeable_fields(BillingInfo, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(BillingInfo, @readable_fields)
  end
end

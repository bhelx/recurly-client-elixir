defmodule Recurly.BillingInfoTest do
  use ExUnit.Case, async: true
  alias Recurly.BillingInfo
  import Utils

  @all_fields ~w(
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
    last_four
    last_name
    month
    number
    phone
    state
    token_id
    vat_number
    verification_value
    year
    zip
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(BillingInfo, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(BillingInfo, @all_fields)
  end
end

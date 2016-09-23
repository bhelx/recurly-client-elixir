defmodule Recurly.TransactionTest do
  use ExUnit.Case, async: true
  alias Recurly.Transaction
  import Utils

  @readable_fields ~w(
    action
    amount_in_cents
    currency
    details
    ip_address
    payment_method
    recurring_type
    reference
    refundable_type
    source
    tax_in_cents
    test_type
    transaction_code
    uuid
    voidable_type
  )a

  @writeable_fields ~w(
    action
    amount_in_cents
    currency
    ip_address
    payment_method
    recurring_type
    reference
    refundable_type
    source
    tax_in_cents
    test_type
    transaction_code
    uuid
    voidable_type
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Transaction, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Transaction, @readable_fields)
  end

  test "Transactions#path should resolve to the transactions endpoint" do
    uuid = "abcdef1234567890"
    assert Transaction.path(uuid) == "/transactions/#{uuid}"
  end
end

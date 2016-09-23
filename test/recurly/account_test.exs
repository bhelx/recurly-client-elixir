defmodule Recurly.AccountTest do
  use ExUnit.Case, async: true
  alias Recurly.Account
  import Utils

  @readable_fields ~w(
    accept_language
    account_code
    address
    billing_info
    cc_emails
    closed_at
    company_name
    created_at
    email
    entity_use_code
    first_name
    last_name
    state
    tax_exempt
    transactions
    updated_at
    username
    vat_number
  )a

  @writeable_fields ~w(
    accept_language
    account_code
    address
    billing_info
    cc_emails
    company_name
    email
    entity_use_code
    first_name
    last_name
    tax_exempt
    transactions
    username
    vat_number
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Account, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Account, @readable_fields)
  end

  test "Account#path should resolve to the accounts endpoint" do
    account_code = "my-account-code"
    assert Account.path(account_code) == "/accounts/#{account_code}"
  end
end

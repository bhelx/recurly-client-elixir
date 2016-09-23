defmodule Recurly.InvoiceTest do
  use ExUnit.Case, async: true
  alias Recurly.Invoice
  import Utils

  @readable_fields ~w(
    account
    address
    closed_at
    created_at
    currency
    customer_notes
    invoice_number
    invoice_number_prefix
    line_items
    net_terms
    po_number
    state
    subtotal_in_cents
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    terms_and_conditions
    total_in_cents
    transactions
    updated_at
    uuid
    vat_number
  )a

  @writeable_fields ~w(
    account
    address
    currency
    customer_notes
    invoice_number
    invoice_number_prefix
    line_items
    net_terms
    po_number
    state
    subtotal_in_cents
    tax_in_cents
    tax_rate
    tax_region
    tax_type
    terms_and_conditions
    total_in_cents
    transactions
    uuid
    vat_number
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Invoice, @writeable_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Invoice, @readable_fields)
  end

  test "Invoice#path should resolve to the invoices endpoint" do
    uuid = "FR1001"
    assert Invoice.path(uuid) == "/invoices/#{uuid}"
  end
end

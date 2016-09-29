defmodule Recurly.Webhooks.PastDueInvoiceNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Invoice}

  test "correctly parses payload" do
    xml_doc = """
      <past_due_invoice_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verana</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <invoice>
          <uuid>ffc64d71d4b5404e93f13aac9c63b007</uuid>
          <subscription_id nil="true"></subscription_id>
          <state>past_due</state>
          <invoice_number_prefix></invoice_number_prefix>
          <invoice_number type="integer">1000</invoice_number>
          <po_number></po_number>
          <vat_number></vat_number>
          <total_in_cents type="integer">1100</total_in_cents>
          <currency>USD</currency>
          <date type="datetime">2014-01-01T20:20:29Z</date>
          <closed_at type="datetime">2014-01-01T20:24:02Z</closed_at>
        </invoice>
      </past_due_invoice_notification>
    """

    notification = %Webhooks.PastDueInvoiceNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    invoice = %Invoice{} = notification.invoice

    assert account.account_code == "1"
    assert invoice.uuid == "ffc64d71d4b5404e93f13aac9c63b007"
  end
end

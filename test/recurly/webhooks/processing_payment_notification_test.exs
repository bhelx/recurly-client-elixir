defmodule Recurly.Webhooks.ProcessingPaymentNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Transaction}

  test "correctly parses payload" do
    xml_doc = """
      <processing_payment_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true">verena</username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true">Company, Inc.</company_name>
        </account>
        <transaction>
          <id>a5143c1d3a6f4a8287d0e2cc1d4c0427</id>
          <invoice_id>1974a09kj90s0789dsf099798326881c</invoice_id>
          <invoice_number_prefix></invoice_number_prefix>
          <invoice_number type="integer">2059</invoice_number>
          <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
          <action>purchase</action>
          <date type="datetime">2009-11-22T13:10:38Z</date>
          <amount_in_cents type="integer">1000</amount_in_cents>
          <status>processing</status>
          <message>Bogus Gateway: Forced success</message>
          <reference></reference>
          <source>subscription</source>
          <cvv_result code=""></cvv_result>
          <avs_result code=""></avs_result>
          <avs_result_street></avs_result_street>
          <avs_result_postal></avs_result_postal>
          <test type="boolean">true</test>
          <voidable type="boolean">true</voidable>
          <refundable type="boolean">true</refundable>
        </transaction>
      </processing_payment_notification>
    """

    notification = %Webhooks.ProcessingPaymentNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    transaction = %Transaction{} = notification.transaction

    assert account.account_code == "1"
    # TODO need to be able to parse id and invoice_id
    # assert transaction.id == "a5143c1d3a6f4a8287d0e2cc1d4c0427"
    # assert transaction.invoice_id == "8fjk3sd7j90s0789dsf099798jkliy65"
    assert transaction.action == "purchase"
  end
end

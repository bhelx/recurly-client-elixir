defmodule Recurly.Webhooks.VoidPaymentNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Transaction}

  test "correctly parses payload" do
    xml_doc = """
      <void_payment_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <transaction>
          <id>4997ace0f57341adb3e857f9f7d15de8</id>
          <invoice_id>ffc64d71d4b5404e93f13aac9c63b007</invoice_id>
          <invoice_number type="integer">2059</invoice_number>
          <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
          <action>purchase</action>
          <date type="datetime">2010-10-05T23:00:50Z</date>
          <amount_in_cents type="integer">235</amount_in_cents>
          <status>void</status>
          <message>Test Gateway: Successful test transaction</message>
          <reference></reference>
          <source>subscription</source>
          <cvv_result code="M">Match</cvv_result>
          <avs_result code="D">Street address and postal code match.</avs_result>
          <avs_result_street></avs_result_street>
          <avs_result_postal></avs_result_postal>
          <test type="boolean">true</test>
          <voidable type="boolean">false</voidable>
          <refundable type="boolean">false</refundable>
        </transaction>
      </void_payment_notification>
    """

    notification = %Webhooks.VoidPaymentNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    transaction = %Transaction{} = notification.transaction

    assert account.account_code == "1"
    # TODO need to be able to parse id and invoice_id
    # assert transaction.id == "a5143c1d3a6f4a8287d0e2cc1d4c0427"
    # assert transaction.invoice_id == "8fjk3sd7j90s0789dsf099798jkliy65"
    assert transaction.action == "purchase"
  end
end

defmodule Recurly.Webhooks.SuccessfulRefundNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Transaction}

  test "correctly parses payload" do
    xml_doc = """
      <successful_refund_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <transaction>
          <id>2c7a2e30547e49869efd4e8a44b2be34</id>
          <invoice_id>ffc64d71d4b5404e93f13aac9c63b007</invoice_id>
          <invoice_number type="integer">2059</invoice_number>
          <subscription_id>1974a098jhlkjasdfljkha898326881c</subscription_id>
          <action>credit</action>
          <date type="datetime">2010-10-06T20:37:55Z</date>
          <amount_in_cents type="integer">235</amount_in_cents>
          <status>success</status>
          <message>Bogus Gateway: Forced success</message>
          <reference></reference>
          <source>subscription</source>
          <cvv_result code=""></cvv_result>
          <avs_result code=""></avs_result>
          <avs_result_street></avs_result_street>
          <avs_result_postal></avs_result_postal>
          <test type="boolean">true</test>
          <voidable type="boolean">true</voidable>
          <refundable type="boolean">false</refundable>
        </transaction>
      </successful_refund_notification>
    """

    notification = %Webhooks.SuccessfulRefundNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    transaction = %Transaction{} = notification.transaction

    assert account.account_code == "1"
    # TODO need to be able to parse id and invoice_id
    # assert transaction.id == "a5143c1d3a6f4a8287d0e2cc1d4c0427"
    # assert transaction.invoice_id == "8fjk3sd7j90s0789dsf099798jkliy65"
    assert transaction.action == "credit"
  end
end

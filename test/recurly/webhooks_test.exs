defmodule Recurly.WebhooksTest do
  use ExUnit.Case, async: true
  alias Recurly.Webhooks

  test "throws ArgumentError if we don't recognize a webhook" do
    xml_doc = """
      <unknown_account_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
      </unknown_account_notification>
    """

    assert_raise ArgumentError, fn ->
      Webhooks.parse(xml_doc)
    end
  end
end

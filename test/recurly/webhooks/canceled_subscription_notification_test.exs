defmodule Recurly.Webhooks.CanceledSubscriptionNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Subscription,Plan}

  test "correctly parses payload" do
    xml_doc = """
      <canceled_subscription_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true"></username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true"></company_name>
        </account>
        <subscription>
          <plan>
            <plan_code>1dpt</plan_code>
            <name>Subscription One</name>
          </plan>
          <uuid>dccd742f4710e78515714d275839f891</uuid>
          <state>canceled</state>
          <quantity type="integer">1</quantity>
          <total_amount_in_cents type="integer">200</total_amount_in_cents>
          <subscription_add_ons type="array"/>
          <activated_at type="datetime">2010-09-23T22:05:03Z</activated_at>
          <canceled_at type="datetime">2010-09-23T22:05:43Z</canceled_at>
          <expires_at type="datetime">2010-09-24T22:05:03Z</expires_at>
          <current_period_started_at type="datetime">2010-09-23T22:05:03Z</current_period_started_at>
          <current_period_ends_at type="datetime">2010-09-24T22:05:03Z</current_period_ends_at>
          <trial_started_at nil="true" type="datetime"></trial_started_at>
          <trial_ends_at nil="true" type="datetime"></trial_ends_at>
          <collection_method>automatic</collection_method>
        </subscription>
      </canceled_subscription_notification>
    """

    notification = %Webhooks.CanceledSubscriptionNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    subscription = %Subscription{} = notification.subscription
    plan = %Plan{} = subscription.plan

    assert account.account_code == "1"
    assert subscription.uuid == "dccd742f4710e78515714d275839f891"
    assert plan.plan_code == "1dpt"
  end
end

defmodule Recurly.Webhooks.UpdatedSubscriptionNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Subscription,Plan}

  test "correctly parses payload" do
    xml_doc = """
      <updated_subscription_notification>
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
          <uuid>292332928954ca62fa48048be5ac98ec</uuid>
          <state>active</state>
          <quantity type="integer">1</quantity>
          <total_amount_in_cents type="integer">200</total_amount_in_cents>
          <subscription_add_ons type="array"/>
          <activated_at type="datetime">2010-09-23T22:12:39Z</activated_at>
          <canceled_at nil="true" type="datetime"></canceled_at>
          <expires_at nil="true" type="datetime"></expires_at>
          <current_period_started_at type="datetime">2010-09-23T22:03:30Z</current_period_started_at>
          <current_period_ends_at type="datetime">2010-09-24T22:03:30Z</current_period_ends_at>
          <trial_started_at nil="true" type="datetime">
          </trial_started_at>
          <trial_ends_at nil="true" type="datetime">
          </trial_ends_at>
          <collection_method>automatic</collection_method>
        </subscription>
      </updated_subscription_notification>
    """

    notification = %Webhooks.UpdatedSubscriptionNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    subscription = %Subscription{} = notification.subscription
    plan = %Plan{} = subscription.plan

    assert account.account_code == "1"
    assert subscription.uuid == "292332928954ca62fa48048be5ac98ec"
    assert plan.plan_code == "1dpt"
  end
end

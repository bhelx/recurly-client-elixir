defmodule Recurly.Webhooks.NewSubscriptionNotificationTest do
  use ExUnit.Case, async: true
  alias Recurly.{Webhooks,Account,Subscription,Plan,SubscriptionAddOn}

  test "correctly parses payload" do
    xml_doc = """
      <new_subscription_notification>
        <account>
          <account_code>1</account_code>
          <username nil="true">verena</username>
          <email>verena@example.com</email>
          <first_name>Verena</first_name>
          <last_name>Example</last_name>
          <company_name nil="true">Company, Inc.</company_name>
        </account>
        <subscription>
          <plan>
            <plan_code>bronze</plan_code>
            <name>Bronze Plan</name>
          </plan>
          <uuid>8047cb4fd5f874b14d713d785436ebd3</uuid>
          <state>active</state>
          <quantity type="integer">2</quantity>
          <total_amount_in_cents type="integer">17000</total_amount_in_cents>
          <subscription_add_ons type="array">
            <subscription_add_on>
              <add_on_code>premium_support</add_on_code>
              <name>Premium Support</name>
              <quantity type="integer">1</quantity>
              <unit_amount_in_cents type="integer">15000</unit_amount_in_cents>
              <add_on_type>fixed</add_on_type>
              <usage_percentage nil="true"></usage_percentage>
              <measured_unit_id nil="true"></measured_unit_id>
            </subscription_add_on>
            <subscription_add_on>
              <add_on_code>email_blasts</add_on_code>
              <name>Email Blasts</name>
              <quantity type="integer">1</quantity>
              <unit_amount_in_cents type="integer">50</unit_amount_in_cents>
              <add_on_type>usage</add_on_type>
              <usage_percentage nil="true"></usage_percentage>
              <measured_unit_id type="integer">394681687402874853</measured_unit_id>
            </subscription_add_on>
            <subscription_add_on>
              <add_on_code>donations</add_on_code>
              <name>Donations</name>
              <quantity type="integer">1</quantity>
              <unit_amount_in_cents nil="true"></unit_amount_in_cents>
              <add_on_type>usage</add_on_type>
              <usage_percentage>0.6</usage_percentage>
              <measured_unit_id type="integer">394681920153192422</measured_unit_id>
            </subscription_add_on>
          </subscription_add_ons>
          <activated_at type="datetime">2009-11-22T13:10:38Z</activated_at>
          <canceled_at type="datetime"></canceled_at>
          <expires_at type="datetime"></expires_at>
          <current_period_started_at type="datetime">2009-11-22T13:10:38Z</current_period_started_at>
          <current_period_ends_at type="datetime">2009-11-29T13:10:38Z</current_period_ends_at>
          <trial_started_at type="datetime">2009-11-22T13:10:38Z</trial_started_at>
          <trial_ends_at type="datetime">2009-11-29T13:10:38Z</trial_ends_at>
          <collection_method>automatic</collection_method>
        </subscription>
      </new_subscription_notification>
    """

    notification = %Webhooks.NewSubscriptionNotification{} = Webhooks.parse(xml_doc)
    account = %Account{} = notification.account
    subscription = %Subscription{} = notification.subscription
    plan = %Plan{} = subscription.plan
    add_on = %SubscriptionAddOn{} = subscription.subscription_add_ons |> List.first

    assert account.account_code == "1"
    assert subscription.uuid == "8047cb4fd5f874b14d713d785436ebd3"
    assert plan.plan_code == "bronze"
    assert add_on.add_on_code == "premium_support"
  end
end

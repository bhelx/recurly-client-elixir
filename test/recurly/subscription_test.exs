defmodule Recurly.SubscriptionTest do
  use ExUnit.Case, async: true

  test "should be able to parse sub from xml" do
    xml_doc = """
      <subscription href="https://api.recurly.com/v2/subscriptions/44f83d7cba354d5b84812419f923ea96">
        <account href="https://api.recurly.com/v2/accounts/1"/>
        <invoice href="https://api.recurly.com/v2/invoices/1108"/>
        <plan href="https://api.recurly.com/v2/plans/gold">
          <plan_code>gold</plan_code>
          <name>Gold plan</name>
        </plan>
        <uuid>44f83d7cba354d5b84812419f923ea96</uuid>
        <state>active</state>
        <unit_amount_in_cents type="integer">800</unit_amount_in_cents>
        <currency>EUR</currency>
        <quantity type="integer">1</quantity>
        <activated_at type="datetime">2016-05-27T07:00:00Z</activated_at>
        <canceled_at nil="nil"></canceled_at>
        <expires_at nil="nil"></expires_at>
        <current_period_started_at type="datetime">2016-06-27T07:00:00Z</current_period_started_at>
        <current_period_ends_at type="datetime">2016-07-27T07:00:00Z</current_period_ends_at>
        <trial_started_at nil="nil"></trial_started_at>
        <trial_ends_at nil="nil"></trial_ends_at>
        <tax_in_cents type="integer">80</tax_in_cents>
        <tax_type>usst</tax_type>
        <tax_region>CA</tax_region>
        <tax_rate type="float">0.0875</tax_rate>
        <po_number nil="nil"></po_number>
        <net_terms type="integer">0</net_terms>
        <subscription_add_ons type="array">
        </subscription_add_ons>
        <a name="cancel" href="https://api.recurly.com/v2/subscriptions/44f83d7cba354d5b84812419f923ea96/cancel" method="put"/>
        <a name="terminate" href="https://api.recurly.com/v2/subscriptions/44f83d7cba354d5b84812419f923ea96/terminate" method="put"/>
      </subscription>
    """

    sub = Recurly.XML.Parser.parse(%Recurly.Subscription{}, xml_doc, false)

    assert sub.uuid == "44f83d7cba354d5b84812419f923ea96"

    plan = sub.plan

    assert plan.name == "Gold plan"
    assert plan.plan_code == "gold"
  end
end

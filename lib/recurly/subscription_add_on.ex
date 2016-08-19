defmodule Recurly.SubscriptionAddOn do
  @moduledoc """
  Module for handling subscription add ons in Recurly.
  See the [developer docs on subscription addons](https://dev.recurly.com/docs/subscription-add-ons)
  for more details
  """
  use Recurly.Resource

  schema :subscription_add_on do
    field :add_on_code,           :string
    field :quantity,              :integer
    field :revenue_schedule_type, :string
    field :unit_amount_in_cents,  Recurly.Money
    field :usage_percentage,      :string
  end
end

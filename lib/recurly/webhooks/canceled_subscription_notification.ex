defmodule Recurly.Webhooks.CanceledSubscriptionNotification do
  @moduledoc """
  Notification for a canceled subscription https://dev.recurly.com/page/webhooks#section-canceled-subscription
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :canceled_subscription_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

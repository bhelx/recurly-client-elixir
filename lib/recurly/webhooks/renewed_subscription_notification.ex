defmodule Recurly.Webhooks.RenewedSubscriptionNotification do
  @moduledoc """
  Notification for a renewed subscription https://dev.recurly.com/page/webhooks#section-renewed-subscription
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :renewed_subscription_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

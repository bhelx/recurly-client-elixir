defmodule Recurly.Webhooks.ExpiredSubscriptionNotification do
  @moduledoc """
  Notification for a expired subscription https://dev.recurly.com/page/webhooks#section-expired-subscription
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :expired_subscription_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

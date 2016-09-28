defmodule Recurly.Webhooks.UpdatedSubscriptionNotification do
  @moduledoc """
  Notification for an updated subscription https://dev.recurly.com/page/webhooks#section-updated-subscription
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :updated_subscription_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

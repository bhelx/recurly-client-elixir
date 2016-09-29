defmodule Recurly.Webhooks.NewSubscriptionNotification do
  @moduledoc """
  Notification for a new subscription https://dev.recurly.com/page/webhooks#section-new-subscription
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :new_subscription_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

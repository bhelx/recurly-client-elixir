defmodule Recurly.Webhooks.ReactivatedAccountNotification do
  @moduledoc """
  Notification for reactivated account https://dev.recurly.com/page/webhooks#section-reactivated-account
  """
  use Recurly.Resource
  alias Recurly.{Account,Subscription}

  schema :reactivated_account_notification do
    field :account,      Account
    field :subscription, Subscription
  end
end

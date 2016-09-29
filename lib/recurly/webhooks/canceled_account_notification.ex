defmodule Recurly.Webhooks.CanceledAccountNotification do
  @moduledoc """
  Notification for canceled account https://dev.recurly.com/page/webhooks#section-closed-account
  """
  use Recurly.Resource
  alias Recurly.Account

  schema :canceled_account_notification do
    field :account, Account
  end
end

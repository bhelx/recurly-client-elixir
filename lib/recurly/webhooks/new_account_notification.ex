defmodule Recurly.Webhooks.NewAccountNotification do
  @moduledoc """
  Notification for new account https://dev.recurly.com/page/webhooks#section-new-account
  """
  use Recurly.Resource
  alias Recurly.Account

  schema :new_account_notification do
    field :account, Account
  end
end

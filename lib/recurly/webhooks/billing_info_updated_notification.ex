defmodule Recurly.Webhooks.BillingInfoUpdatedNotification do
  @moduledoc """
  Notification for updated billing info https://dev.recurly.com/page/webhooks#section-updated-billing-information
  """
  use Recurly.Resource
  alias Recurly.Account

  schema :billing_info_updated_notification do
    field :account, Account
  end
end

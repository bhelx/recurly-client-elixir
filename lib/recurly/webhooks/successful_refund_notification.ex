defmodule Recurly.Webhooks.SuccessfulRefundNotification do
  @moduledoc """
  Notification for a successful refund https://dev.recurly.com/page/webhooks#section-successful-refund
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :successful_refund_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

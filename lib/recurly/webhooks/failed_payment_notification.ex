defmodule Recurly.Webhooks.FailedPaymentNotification do
  @moduledoc """
  Notification for a failed payment https://dev.recurly.com/page/webhooks#section-failed-payment-only-for-ach-payments-
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :failed_payment_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

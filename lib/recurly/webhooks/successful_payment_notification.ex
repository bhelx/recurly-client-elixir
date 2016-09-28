defmodule Recurly.Webhooks.SuccessfulPaymentNotification do
  @moduledoc """
  Notification for a successful payment https://dev.recurly.com/page/webhooks#section-successful-payment-only-for-ach-payments-
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :successful_payment_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

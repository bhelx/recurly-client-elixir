defmodule Recurly.Webhooks.ProcessingPaymentNotification do
  @moduledoc """
  Notification for a processing payment (ACH only) https://dev.recurly.com/page/webhooks#section-processing-payment-only-for-ach-payments-
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :processing_payment_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

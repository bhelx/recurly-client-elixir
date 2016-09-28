defmodule Recurly.Webhooks.ScheduledPaymentNotification do
  @moduledoc """
  Notification for a scheduled payment (ACH only) https://dev.recurly.com/page/webhooks#section-scheduled-payment-only-for-ach-payments-
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :scheduled_payment_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

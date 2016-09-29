defmodule Recurly.Webhooks.VoidPaymentNotification do
  @moduledoc """
  Notification for a voided payment https://dev.recurly.com/page/webhooks#section-void-payment
  """
  use Recurly.Resource
  alias Recurly.{Account,Transaction}

  schema :void_payment_notification do
    field :account,     Account
    field :transaction, Transaction
  end
end

defmodule Recurly.Webhooks.NewInvoiceNotification do
  @moduledoc """
  Notification for a new invoice https://dev.recurly.com/page/webhooks#invoice-notifications
  """
  use Recurly.Resource
  alias Recurly.{Account,Invoice}

  schema :new_invoice_notification do
    field :account, Account
    field :invoice, Invoice
  end
end

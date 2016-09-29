defmodule Recurly.Webhooks.ClosedInvoiceNotification do
  @moduledoc """
  Notification for closed invoice https://dev.recurly.com/page/webhooks#section-closed-invoice
  """
  use Recurly.Resource
  alias Recurly.{Account,Invoice}

  schema :closed_invoice_notification do
    field :account, Account
    field :invoice, Invoice
  end
end

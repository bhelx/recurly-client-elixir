defmodule Recurly.Webhooks.PastDueInvoiceNotification do
  @moduledoc """
  Notification for a new invoice https://dev.recurly.com/page/webhooks#section-past-due-invoichttps://dev.recurly.com/page/webhooks#invoice-notifications
  """
  use Recurly.Resource
  alias Recurly.{Account,Invoice}

  schema :past_due_invoice_notification do
    field :account, Account
    field :invoice, Invoice
  end
end

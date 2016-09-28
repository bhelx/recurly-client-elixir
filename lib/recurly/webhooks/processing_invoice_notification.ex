defmodule Recurly.Webhooks.ProcessingInvoiceNotification do
  @moduledoc """
  Notification for processing invoice (ACH only) https://dev.recurly.com/page/webhooks#section-processing-invoice-automatic-only-for-ach-payments-
  """
  use Recurly.Resource
  alias Recurly.{Account,Invoice}

  schema :processing_invoice_notification do
    field :account, Account
    field :invoice, Invoice
  end
end

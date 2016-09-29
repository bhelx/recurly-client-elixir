defmodule Recurly.Webhooks do
  import SweetXml
  alias Recurly.{Webhooks,XML}

  def parse(xml_doc) do
    xml_doc
    |> notification_name
    |> resource
    |> XML.Parser.parse(xml_doc, false)
  end

  defp notification_name(xml_doc) do
    xpath(xml_doc, ~x"name(.)")
  end

  defp resource('billing_info_updated_notification'),  do: %Webhooks.BillingInfoUpdatedNotification{}
  defp resource('canceled_account_notification'),      do: %Webhooks.CanceledAccountNotification{}
  defp resource('canceled_subscription_notification'), do: %Webhooks.CanceledSubscriptionNotification{}
  defp resource('closed_invoice_notification'),        do: %Webhooks.ClosedInvoiceNotification{}
  defp resource('expired_subscription_notification'),  do: %Webhooks.ExpiredSubscriptionNotification{}
  defp resource('failed_payment_notification'),        do: %Webhooks.FailedPaymentNotification{}
  defp resource('new_account_notification'),           do: %Webhooks.NewAccountNotification{}
  defp resource('new_invoice_notification'),           do: %Webhooks.NewInvoiceNotification{}
  defp resource('new_subscription_notification'),      do: %Webhooks.NewSubscriptionNotification{}
  defp resource('past_due_invoice_notification'),      do: %Webhooks.PastDueInvoiceNotification{}
  defp resource('processing_invoice_notification'),    do: %Webhooks.ProcessingInvoiceNotification{}
  defp resource('processing_payment_notification'),    do: %Webhooks.ProcessingPaymentNotification{}
  defp resource('reactivated_account_notification'),   do: %Webhooks.ReactivatedAccountNotification{}
  defp resource('renewed_subscription_notification'),  do: %Webhooks.RenewedSubscriptionNotification{}
  defp resource('scheduled_payment_notification'),     do: %Webhooks.ScheduledPaymentNotification{}
  defp resource('successful_payment_notification'),    do: %Webhooks.SuccessfulPaymentNotification{}
  defp resource('successful_refund_notification'),     do: %Webhooks.SuccessfulRefundNotification{}
  defp resource('updated_subscription_notification'),  do: %Webhooks.UpdatedSubscriptionNotification{}
  defp resource('void_payment_notification'),          do: %Webhooks.VoidPaymentNotification{}
  defp resource(attr_name) do
    raise ArgumentError, message: "xml attribute #{attr_name} is not supported"
  end
end

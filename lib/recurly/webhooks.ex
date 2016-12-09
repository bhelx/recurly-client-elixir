defmodule Recurly.Webhooks do
  @moduledoc """
  Module responsible for parsing webhooks: https://dev.recurly.com/page/webhooks

  Each webhook has it's own type. These types are returned from `Recurly.Webhooks.parse/1` respectively.

  * [BillingInfoUpdatedNotification](https://dev.recurly.com/page/webhooks#section-updated-billing-information)
  * [CanceledAccountNotification](https://dev.recurly.com/page/webhooks#section-closed-account)
  * [CanceledSubscriptionNotification](https://dev.recurly.com/page/webhooks#section-canceled-subscription)
  * [ClosedInvoiceNotification](https://dev.recurly.com/page/webhooks#section-closed-invoice)
  * [ExpiredSubscriptionNotification](https://dev.recurly.com/page/webhooks#section-expired-subscription)
  * [FailedPaymentNotification](https://dev.recurly.com/page/webhooks#section-failed-payment-only-for-ach-payments-)
  * [NewAccountNotification](https://dev.recurly.com/page/webhooks#section-new-account)
  * [NewInvoiceNotification](https://dev.recurly.com/page/webhooks#invoice-notifications)
  * [NewSubscriptionNotification](https://dev.recurly.com/page/webhooks#section-new-subscription)
  * [PastDueInvoiceNotification](https://dev.recurly.com/page/webhooks#section-past-due-invoichttps://dev.recurly.com/page/webhooks#invoice-notifications)
  * [ProcessingInvoiceNotification](https://dev.recurly.com/page/webhooks#section-processing-invoice-automatic-only-for-ach-payments-)
  * [ProcessingPaymentNotification](https://dev.recurly.com/page/webhooks#section-processing-payment-only-for-ach-payments-)
  * [ReactivatedAccountNotification](https://dev.recurly.com/page/webhooks#section-reactivated-account)
  * [RenewedSubscriptionNotification](https://dev.recurly.com/page/webhooks#section-renewed-subscription)
  * [ScheduledPaymentNotification](https://dev.recurly.com/page/webhooks#section-scheduled-payment-only-for-ach-payments-)
  * [SuccessfulPaymentNotification](https://dev.recurly.com/page/webhooks#section-successful-payment-only-for-ach-payments-)
  * [SuccessfulRefundNotification](https://dev.recurly.com/page/webhooks#section-successful-refund)
  * [UpdatedSubscriptionNotification](https://dev.recurly.com/page/webhooks#section-updated-subscription)
  * [VoidPaymentNotification](https://dev.recurly.com/page/webhooks#section-void-payment)
  """

  import SweetXml
  alias Recurly.XML

  @doc """
  Parses an xml document containing a webhook

  ## Parameters

  - `xml_doc` String webhook xml

  ## Examples

  ```
  xml_doc = \"""
    <?xml version="1.0" encoding="UTF-8"?>
    <canceled_account_notification>
      <account>
        <account_code>1</account_code>
        <username nil="true"></username>
        <email>verena@example.com</email>
        <first_name>Verena</first_name>
        <last_name>Example</last_name>
        <company_name nil="true"></company_name>
      </account>
    </canceled_account_notification>
  \"""

  alias Recurly.Webhooks

  notification = Webhooks.parse(xml_doc)

  # It may be helpful to pattern match against the possible types

  case Webhooks.parse(xml_doc) do
    %Webhooks.CanceledAccountNotification{} n -> IO.inspect(n.account)
    %Webhooks.CanceledSubscriptionNotification{} n -> IO.inspect(n.subscription)
    # ... etc
    _ -> IO.puts("not handled")
  end
  ```
  """
  def parse(xml_doc) do
    xml_doc
    |> notification_name
    |> resource
    |> XML.Parser.parse(xml_doc, false)
  end

  @doc """
  Gives you the name of the notification from the xml

  ## Parameters

  - `xml_doc` String webhook xml

  ## Examples

  ```
  xml_doc = \"""
    <?xml version="1.0" encoding="UTF-8"?>
    <canceled_account_notification>
      <account>
        <account_code>1</account_code>
        <username nil="true"></username>
        <email>verena@example.com</email>
        <first_name>Verena</first_name>
        <last_name>Example</last_name>
        <company_name nil="true"></company_name>
      </account>
    </canceled_account_notification>
  \"""

  "canceled_account_notification" = Recurly.Webhooks.parse(xml_doc)
  ```
  """
  def notification_name(xml_doc) do
    xpath(xml_doc, ~x"name(.)")
  end

  defmodule BillingInfoUpdatedNotification do
    @moduledoc false
    use Recurly.Resource

    schema :billing_info_updated_notification do
      field :account, Recurly.Account
    end
  end

  defmodule CanceledAccountNotification do
    @moduledoc false
    use Recurly.Resource

    schema :canceled_account_notification do
      field :account, Recurly.Account
    end
  end

  defmodule CanceledSubscriptionNotification do
    @moduledoc false
    use Recurly.Resource

    schema :canceled_subscription_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule ClosedInvoiceNotification do
    @moduledoc false
    use Recurly.Resource

    schema :closed_invoice_notification do
      field :account, Recurly.Account
      field :invoice, Recurly.Invoice
    end
  end

  defmodule ExpiredSubscriptionNotification do
    @moduledoc false
    use Recurly.Resource

    schema :expired_subscription_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule FailedPaymentNotification do
    @moduledoc false
    use Recurly.Resource

    schema :failed_payment_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defmodule NewAccountNotification do
    @moduledoc false
    use Recurly.Resource

    schema :new_account_notification do
      field :account, Recurly.Account
    end
  end

  defmodule NewInvoiceNotification do
    @moduledoc false
    use Recurly.Resource

    schema :new_invoice_notification do
      field :account, Recurly.Account
      field :invoice, Recurly.Invoice
    end
  end

  defmodule NewSubscriptionNotification do
    @moduledoc false
    use Recurly.Resource

    schema :new_subscription_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule PastDueInvoiceNotification do
    @moduledoc false
    use Recurly.Resource

    schema :past_due_invoice_notification do
      field :account, Recurly.Account
      field :invoice, Recurly.Invoice
    end
  end

  defmodule ProcessingInvoiceNotification do
    @moduledoc false
    use Recurly.Resource

    schema :processing_invoice_notification do
      field :account, Recurly.Account
      field :invoice, Recurly.Invoice
    end
  end

  defmodule ProcessingPaymentNotification do
    @moduledoc false
    use Recurly.Resource

    schema :processing_payment_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defmodule ReactivatedAccountNotification do
    @moduledoc false
    use Recurly.Resource

    schema :reactivated_account_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule RenewedSubscriptionNotification do
    @moduledoc false
    use Recurly.Resource

    schema :renewed_subscription_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule ScheduledPaymentNotification do
    @moduledoc false
    use Recurly.Resource

    schema :scheduled_payment_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defmodule SuccessfulPaymentNotification do
    @moduledoc false
    use Recurly.Resource

    schema :successful_payment_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defmodule SuccessfulRefundNotification do
    @moduledoc false
    use Recurly.Resource

    schema :successful_refund_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defmodule UpdatedSubscriptionNotification do
    @moduledoc false
    use Recurly.Resource

    schema :updated_subscription_notification do
      field :account,      Recurly.Account
      field :subscription, Recurly.Subscription
    end
  end

  defmodule VoidPaymentNotification do
    @moduledoc false
    use Recurly.Resource

    schema :void_payment_notification do
      field :account,     Recurly.Account
      field :transaction, Recurly.Transaction
    end
  end

  defp resource('billing_info_updated_notification'),  do: %BillingInfoUpdatedNotification{}
  defp resource('canceled_account_notification'),      do: %CanceledAccountNotification{}
  defp resource('canceled_subscription_notification'), do: %CanceledSubscriptionNotification{}
  defp resource('closed_invoice_notification'),        do: %ClosedInvoiceNotification{}
  defp resource('expired_subscription_notification'),  do: %ExpiredSubscriptionNotification{}
  defp resource('failed_payment_notification'),        do: %FailedPaymentNotification{}
  defp resource('new_account_notification'),           do: %NewAccountNotification{}
  defp resource('new_invoice_notification'),           do: %NewInvoiceNotification{}
  defp resource('new_subscription_notification'),      do: %NewSubscriptionNotification{}
  defp resource('past_due_invoice_notification'),      do: %PastDueInvoiceNotification{}
  defp resource('processing_invoice_notification'),    do: %ProcessingInvoiceNotification{}
  defp resource('processing_payment_notification'),    do: %ProcessingPaymentNotification{}
  defp resource('reactivated_account_notification'),   do: %ReactivatedAccountNotification{}
  defp resource('renewed_subscription_notification'),  do: %RenewedSubscriptionNotification{}
  defp resource('scheduled_payment_notification'),     do: %ScheduledPaymentNotification{}
  defp resource('successful_payment_notification'),    do: %SuccessfulPaymentNotification{}
  defp resource('successful_refund_notification'),     do: %SuccessfulRefundNotification{}
  defp resource('updated_subscription_notification'),  do: %UpdatedSubscriptionNotification{}
  defp resource('void_payment_notification'),          do: %VoidPaymentNotification{}
  defp resource(attr_name) do
    raise ArgumentError, message: "xml attribute #{attr_name} is not supported"
  end
end

defmodule Recurly.BillingInfo do
  @moduledoc """
  Module for handling billing infos in Recurly.
  See the [developer docs on billing infos](https://dev.recurly.com/docs/lookup-an-accounts-billing-info)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Account

  schema :billing_info do
    field :account,                     Account, read_only: true
    field :account_number,              :string
    field :account_type,                :string
    field :address1,                    :string
    field :address2,                    :string
    field :card_type,                   :string
    field :city,                        :string
    field :company,                     :string
    field :country,                     :string
    field :currency,                    :string
    field :first_name,                  :string
    field :first_six,                   :string
    field :ip_address,                  :string
    field :ip_address_country,          :string
    field :last_four,                   :string
    field :last_name,                   :string
    field :month,                       :integer
    field :name_on_account,             :string
    field :number,                      :string
    field :paypal_billing_agreement_id, :string
    field :phone,                       :string
    field :routing_number,              :string
    field :state,                       :string
    field :token_id,                    :string
    field :vat_number,                  :string
    field :verification_value,          :string
    field :year,                        :integer
    field :zip,                         :string
  end
end

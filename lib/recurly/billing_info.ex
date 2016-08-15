defmodule Recurly.BillingInfo do
  @moduledoc """
  Module for handling billing infos in Recurly.
  See the [developer docs on billing infos](https://dev.recurly.com/docs/lookup-an-accounts-billing-info)
  for more details
  """
  use Recurly.Resource

  schema :billing_info do
    field :address1,           :string
    field :address2,           :string
    field :card_type,          :string
    field :city,               :string
    field :company,            :string
    field :country,            :string
    field :currency,           :string
    field :first_name,         :string
    field :first_six,          :string
    field :ip_address,         :string
    field :last_four,          :string
    field :last_name,          :string
    field :month,              :integer
    field :number,             :string
    field :phone,              :string
    field :state,              :string
    field :token_id,           :string
    field :vat_number,         :string
    field :verification_value, :string
    field :year,               :integer
    field :zip,                :string
  end
end

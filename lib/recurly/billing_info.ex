defmodule Recurly.BillingInfo do
  @moduledoc """
  Module for handling billing infos in Recurly.
  See the [developer docs on billing infos](https://dev.recurly.com/docs/lookup-an-accounts-billing-info)
  for more details
  """
  use Recurly.Resource

  schema :billing_info do
    field :address1
    field :address2
    field :card_type
    field :city
    field :company
    field :country
    field :currency
    field :first_name
    field :first_six
    field :ip_address
    field :last_four
    field :last_name
    field :month, :integer
    field :number
    field :phone
    field :state
    field :token_id
    field :vat_number
    field :verification_value
    field :year, :integer
    field :zip
  end
end

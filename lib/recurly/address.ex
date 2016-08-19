defmodule Recurly.Address do
  @moduledoc """
  Module representing an address in Recurly.
  """
  use Recurly.Resource

  schema :address do
    field :address1, :string
    field :address2, :string
    field :city,     :string
    field :country,  :string
    field :phone,    :string
    field :state,    :string
    field :zip,      :string
  end
end

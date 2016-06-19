defmodule Recurly.Address do
  @moduledoc """
  Module representing an address in Recurly.
  """
  use Recurly.Resource

  schema :address do
    field :address1
    field :address2
    field :city
    field :country
    field :phone
    field :state
    field :zip
  end
end

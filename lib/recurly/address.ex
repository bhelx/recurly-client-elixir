defmodule Recurly.Address do
  @moduledoc """
  Module representing an address in Recurly.
  """
  use Recurly.Resource

  @type t :: %__MODULE__{
    address1: String.t,
    address2: String.t,
    city:     String.t,
    country:  String.t,
    phone:    String.t,
    state:    String.t,
    zip:      String.t,
  }

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

defmodule Recurly.Money do
  @moduledoc """
  A module representing an amount of money that may
  be in different currencies. Sort of a naive implementation.
  """
  use Recurly.Resource

  # TODO could maybe be smarter?
  # Could use a map or something
  schema :money do
    field :AUD, :integer
    field :BRL, :integer
    field :GBP, :integer
    field :CAD, :integer
    field :CZK, :integer
    field :DKK, :integer
    field :EUR, :integer
    field :HUF, :integer
    field :INR, :integer
    field :ILS, :integer
    field :MXN, :integer
    field :NOK, :integer
    field :NZD, :integer
    field :PLN, :integer
    field :SGD, :integer
    field :SEK, :integer
    field :CHF, :integer
    field :ZAR, :integer
    field :USD, :integer
  end
end

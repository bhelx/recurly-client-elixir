defmodule Recurly.Money do
  @moduledoc """
  A module representing an amount of money that may
  be in different currencies. Sort of a naive implementation.
  """
  use Recurly.Resource

  @type t :: %__MODULE__{
    AUD: integer,
    BRL: integer,
    GBP: integer,
    CAD: integer,
    CZK: integer,
    DKK: integer,
    EUR: integer,
    HUF: integer,
    INR: integer,
    ILS: integer,
    MXN: integer,
    NOK: integer,
    NZD: integer,
    PLN: integer,
    SGD: integer,
    SEK: integer,
    CHF: integer,
    ZAR: integer,
    USD: integer,
  }

  # TODO could maybe be smarter? Could use a map or something
  # maybe we just need to change the inspect implementation
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

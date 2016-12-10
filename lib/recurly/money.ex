defmodule Recurly.Money do
  @moduledoc """
  A module representing an amount of money that may
  be in different currencies. Sort of a naive implementation.
  """
  use Recurly.Resource

  # TODO could maybe be smarter?
  # Could use a map or something
  schema :money do
    field :aud, :integer
    field :brl, :integer
    field :cad, :integer
    field :chf, :integer
    field :czk, :integer
    field :dkk, :integer
    field :eur, :integer
    field :gbp, :integer
    field :huf, :integer
    field :ils, :integer
    field :inr, :integer
    field :mxn, :integer
    field :nok, :integer
    field :nzd, :integer
    field :pln, :integer
    field :sek, :integer
    field :sgd, :integer
    field :usd, :integer
    field :zar, :integer
  end
end

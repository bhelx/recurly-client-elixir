defmodule Recurly.MoneyTest do
  use ExUnit.Case, async: true
  alias Recurly.Money
  import Utils

  @all_fields ~w(
    aud
    brl
    cad
    chf
    czk
    dkk
    eur
    gbp
    huf
    ils
    inr
    mxn
    nok
    nzd
    pln
    sek
    sgd
    usd
    zar
  )a

  test "should maintain the list of writeable fields" do
    compare_writeable_fields(Money, @all_fields)
  end

  test "should maintain the list of readable fields" do
    compare_readable_fields(Money, @all_fields)
  end
end

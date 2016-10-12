defmodule Recurly.MoneyTest do
  use ExUnit.Case, async: true
  alias Recurly.Money
  import Utils

  @all_fields ~w(
    AUD
    BRL
    CAD
    CHF
    CZK
    DKK
    EUR
    GBP
    HUF
    ILS
    INR
    MXN
    NOK
    NZD
    PLN
    SEK
    SGD
    USD
    ZAR
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Money, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Money, @all_fields)
  end
end

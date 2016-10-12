defmodule Recurly.AddressTest do
  use ExUnit.Case, async: true
  alias Recurly.Address
  import Utils

  @all_fields ~w(
    address1
    address2
    city
    country
    phone
    state
    zip
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(Address, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(Address, @all_fields)
  end
end

defmodule Recurly.TransactionDetailsTest do
  use ExUnit.Case, async: true
  alias Recurly.TransactionDetails
  import Utils

  @all_fields ~w(
    account
  )a

  test "should maintain the list of writeable fields" do
    assert compare_writeable_fields(TransactionDetails, @all_fields)
  end

  test "should maintain the list of readable fields" do
    assert compare_readable_fields(TransactionDetails, @all_fields)
  end
end

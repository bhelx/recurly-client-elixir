defmodule Recurly.XML.FieldTest do
  use ExUnit.Case, async: true
  alias Recurly.XML

  setup do
    schema = XML.Schema.get(MyResource)
    {:ok, schema: schema}
  end

  test "Field#read_only? returns true if read_only found in opts", %{schema: schema} do
    field = XML.Schema.find_field(schema, :a_read_only)
    assert XML.Field.read_only?(field) == true
  end

  test "Field#read_only? returns false if read_only not found in opts", %{schema: schema} do
    field = XML.Schema.find_field(schema, :a_string)
    assert XML.Field.read_only?(field) == false
  end

  test "Field#pageable? returns true if list found in opts", %{schema: schema} do
    field = XML.Schema.find_field(schema, :an_array)
    assert XML.Field.pageable?(field) == true
  end

  test "Field#pageable? returns false if list not found in opts", %{schema: schema} do
    field = XML.Schema.find_field(schema, :a_string)
    assert XML.Field.pageable?(field) == false
  end
end

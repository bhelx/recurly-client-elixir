defmodule Recurly.XML.SchemaTest do
  use ExUnit.Case, async: true
  alias Recurly.XML.{Schema,Field}

  defmodule MyResource do
    use Recurly.XML.Schema

    schema :my_resource do
      field :a_string, :string
      field :an_integer, :integer
      field :a_float, :float, read_only: true
    end
  end

  test "Schema#get returns the schema of a resource_type" do
    schema = Schema.get(MyResource)
    assert schema.resource_type == MyResource
  end

  test "creates a struct with the keys from the schema" do
    resource = %MyResource{}
    assert Map.keys(resource) == ~w(__meta__ __struct__ a_float a_string an_integer)a
  end

  test "defines a __schema__ function on the module returning the schema" do
    test_schema = %Schema{
      fields: [
        %Field{name: :a_string, type: :string, opts: []},
        %Field{name: :an_integer, type: :integer, opts: []},
        %Field{name: :a_float, type: :float, opts: [read_only: true]}
      ],
      resource_type: MyResource
    }

    assert MyResource.__schema__ == test_schema
  end

  test "defines a __resource_name__ function on the module returning the resource's name" do
    assert MyResource.__resource_name__ == :my_resource
  end
end

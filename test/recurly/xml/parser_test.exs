defmodule Recurly.XML.ParserTest do
  use ExUnit.Case, async: true

  def is_my_resource(%MyResource{}), do: true
  def is_my_resource(_), do: false

  def is_my_embedded_resource(%MyEmbeddedResource{}), do: true
  def is_my_embedded_resource(_), do: false

  test "parses xml into resource" do
    xml_doc = """
      <my_resource href="https://api.recurly.com/my_resource/1234">
        <a_string>String</a_string>
        <an_integer type="integer">123</an_integer>
        <a_float type="float">3.14</a_float>
        <a_boolean type="boolean">true</a_boolean>
        <a_date_time>2016-08-14T06:42:15.675780Z</a_date_time>
        <not_in_schema>Not in Schema, Should be ignored</not_in_schema>
        <an_embedded_resource href="https://api.recurly.com/my_resource/1234/my_embedded_resource/5678">
          <name>I am embedded</name>
        </an_embedded_resource>
        <an_array type="array">
          <an_embedded_resource>
            <name>Element 1</name>
          </an_embedded_resource>
          <an_embedded_resource>
            <name>Element 2</name>
          </an_embedded_resource>
        </an_array>
        <a name="myaction" href="https://api.recurly.com/my_resource/1234/myaction" method="post" />
      </my_resource>
    """

    resource = Recurly.XML.Parser.parse(%MyResource{}, xml_doc, false)

    assert is_my_resource(resource) == true
    assert resource.a_string == "String"
    assert resource.an_integer == 123
    assert resource.a_float == 3.14
    assert resource.a_boolean == true
    assert {:ok, resource.a_date_time} == NaiveDateTime.from_iso8601("2016-08-14T06:42:15.675780Z")

    meta = resource.__meta__
    assert meta.href == "https://api.recurly.com/my_resource/1234"
    assert meta.actions == %{
      myaction: [
        :post,
        "https://api.recurly.com/my_resource/1234/myaction"
      ]
    }

    embedded_resource = resource.an_embedded_resource

    assert is_my_embedded_resource(embedded_resource) == true
    assert embedded_resource.name == "I am embedded"

    meta = embedded_resource.__meta__
    assert meta.href == "https://api.recurly.com/my_resource/1234/my_embedded_resource/5678"

    assert is_list(resource.an_array)

    element1 = List.first(resource.an_array)
    element2 = List.last(resource.an_array)

    assert element1.name == "Element 1"
    assert element2.name == "Element 2"
  end

  test "parses xml list into list of resources" do
    xml_doc = """
      <my_resources>
        <my_resource href="https://api.recurly.com/my_resource/1234">
          <a_string>String</a_string>
          <an_integer type="integer">123</an_integer>
          <a_float type="float">3.14</a_float>
        </my_resource>
        <my_resource href="https://api.recurly.com/my_resource/5678">
          <a_string>String</a_string>
          <an_integer type="integer">123</an_integer>
          <a_float type="float">3.14</a_float>
        </my_resource>
      </my_resources>
    """

    resources = Recurly.XML.Parser.parse(%MyResource{}, xml_doc, true)

    assert length(resources) == 2

    resource = List.first(resources)
    assert is_my_resource(resource) == true
    assert resource.a_string == "String"
    assert resource.an_integer == 123
    assert resource.a_float == 3.14

    meta = resource.__meta__
    assert meta.href == "https://api.recurly.com/my_resource/1234"

    resource = List.last(resources)
    assert is_my_resource(resource) == true
    assert resource.a_string == "String"
    assert resource.an_integer == 123
    assert resource.a_float == 3.14

    meta = resource.__meta__
    assert meta.href == "https://api.recurly.com/my_resource/5678"
  end

  test "throws an ArgumentError for an invalid boolean" do
    xml_doc = """
      <my_resource>
        <a_boolean type="boolean">invalid</a_boolean>
      </my_resource>
    """

    assert_raise ArgumentError, fn ->
      _resource = Recurly.XML.Parser.parse(%MyResource{}, xml_doc, false)
    end
  end
end

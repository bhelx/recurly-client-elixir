defmodule Recurly.ErrorsTest do
  use ExUnit.Case, async: true

  test "parses APIError" do
    xml_doc = """
      <error>
        <symbol>error_symbol</symbol>
        <description>Error Description</description>
      </error>
    """

    expected = %Recurly.APIError{
      symbol: :error_symbol,
      description: "Error Description"
    }

    error = Recurly.XML.Parser.parse(%Recurly.APIError{}, xml_doc, false)

    assert error == expected
  end

  test "parses NotFoundError" do
    xml_doc = """
      <error>
        <symbol>not_found</symbol>
        <description>The record could not be located.</description>
      </error>
    """

    expected = %Recurly.NotFoundError{
      symbol: :not_found,
      description: "The record could not be located."
    }

    error = Recurly.XML.Parser.parse(%Recurly.NotFoundError{}, xml_doc, false)

    assert error == expected
  end

  test "parses ValidationError" do
    xml_doc = """
      <errors>
        <error field="model_name.number_field" symbol="not_a_number" lang="en-US">is not a number</error>
        <error field="model_name.date_field" symbol="in_past">must be in the future</error>
      </errors>
    """

    expected = %Recurly.ValidationError{
      errors: [
        %{symbol: :not_a_number, field: "model_name.number_field", lang: "en-US", text: "is not a number"},
        %{symbol: :in_past, field: "model_name.date_field", lang: "", text: "must be in the future"}
      ]
    }

    error = Recurly.XML.Parser.parse(%Recurly.ValidationError{}, xml_doc, false)

    assert error == expected
  end
end

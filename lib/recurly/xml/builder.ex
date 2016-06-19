defmodule Recurly.XML.Builder do
  import XmlBuilder
  alias Recurly.XML.Types
  alias Recurly.XML.Schema
  alias Recurly.XML.Field

  @doc """
  Generates an xml document representing a changeset.

  ## Parameters

    - `changeset` Keyword list changeset
    - `resource_type` Module representing the resource type

  ## Examples

  ```
  changeset = [account_code: "my_account", first_name: nil]
  Recurly.XML.Builder.generate(changeset, Recurly.Account)

  # <account>
  #   <account_code>my_account</account_code>
  #   <first_name nil="nil"></first_name>
  # </account>
  ```
  """
  def generate(changeset, resource_type) do
    resource_name = resource_type.__resource_name__

    resource_name
    |> element(nil, to_elements(changeset, resource_type))
    |> XmlBuilder.generate
  end

  # TODO requires a refactoring
  defp to_elements(changeset, resource_type) do
    schema = Schema.get(resource_type)
    writeable_fields = Schema.fields(schema, :writeable)

    changeset
    |> Enum.map(fn {attr_name, attr_value} ->
      field = Schema.find_field(schema, attr_name)

      unless field do
        raise ArgumentError, message: "Invalid changeset data #{inspect({attr_name, attr_value})} for resource #{inspect(resource_type)}"
      end

      if attr_value do
        attr_type = field.type
        if attr_type do
          cond do
            Types.primitive?(attr_type) -> # Simple primitive element
              element(attr_name, nil, attr_value)
            Field.array?(field) -> # check to see if array type
              items = Enum.map(attr_value, fn v ->
                name = elem(v, 0)
                attrs = elem(v, 1)
                element(name, nil, to_elements(attrs, attr_type))
              end)
              element(attr_name, %{"type" => "array"}, items)
            true -> # Embedded type, must be unwrapped
              element(attr_name, to_elements(attr_value, attr_type))
          end
        end
      else
        element(attr_name, %{"nil" => "nil"}, nil)
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end

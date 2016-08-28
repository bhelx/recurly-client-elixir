defmodule Recurly.XML.Builder do
  @moduledoc """
  Module responsible for building XML documents. Mostly
  for internal use. API unstable.
  """

  import XmlBuilder
  alias Recurly.XML.{Types,Schema,Field}

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

  # if you give it a field that is not in the
  # resource's field, it will throw an ArgumentError
  # let's assume you misspell account `acount`

  changeset = [acount_code: "my_account", first_name: nil]
  Recurly.XML.Builder.generate(changeset, Recurly.Account)
  #=> raises ArgumentError "Invalid changeset data {:acount, "my_account"} for resource Recurly.Account"
  ```
  """
  def generate(changeset, resource_type) do
    resource_name = resource_type.__resource_name__

    resource_name
    |> element(nil, to_elements(changeset, resource_type))
    |> XmlBuilder.generate
  end

  @doc """
  Turns a changeset and associated resource type into a nested
  tuple which can be turned into xml by `XmlBuilder`
  """
  def to_elements(changeset, resource_type) do
    changeset
    |> Enum.map(&find_field(&1, resource_type))
    |> Enum.map(&to_element/1)
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Given an attribute tuple from a changeset and a resource type, find and
  append the field from the schema

  ## Parameters

  - `attr_tuple` {attr_name, attr_value} from the changset
  - `resource_type` Module which is responsible for the changset data

  ## Examples

  ```
  alias Recurly.XML.Field

  Recurly.XML.Builder.find_field({:account_code, "xyz"}, Recurly.Account)
  #=> {:account_code, "xyz", %Field{name: :account_code, type: :string, opts: []}}
  ```
  """
  def find_field({attr_name, attr_value}, resource_type) do
    schema = Schema.get(resource_type)
    field = Schema.find_field(schema, attr_name)

    unless field do
      msg = "Invalid changeset data #{inspect({attr_name, attr_value})} for resource #{inspect(resource_type)}"
      raise ArgumentError, message: msg
    end

    {attr_name, attr_value, field}
  end

  @doc """
  Takes a tuple from changeset data and returns an xml element

  ## Parameters

  - `changset_tuple` - contains the attribute name, the attribute value, and the `Recurly.XML.Field`.

  ## Examples

  ```
  alias Recurly.XML.Field

  field = %Field{name: :account_code, type: :string, opts: []}

  Recurly.XML.Builder.to_element({:account_code, "xyz", field})
  #=> {:account_code, nil, "xyz"}
  ```
  """
  def to_element({attr_name, nil, _field}) do
    element(attr_name, %{"nil" => "nil"}, nil)
  end
  def to_element({attr_name, attr_value, %Field{type: :date_time}}) do
    attr_value = NaiveDateTime.to_iso8601(attr_value)
    element(attr_name, %{"type" => "datetime"}, attr_value)
  end
  def to_element({attr_name, attr_value, field = %Field{opts: [list: true]}}) do
    items = Enum.map(attr_value, fn v ->
      child_name = elem(v, 0)
      attributes = elem(v, 1)
      element(child_name, nil, to_elements(attributes, field.type))
    end)
    element(attr_name, %{"type" => "array"}, items)
  end
  def to_element({attr_name, attr_value, field}) do
    if Types.primitive?(field.type) do # Simple primitive element
      element(attr_name, nil, attr_value)
    else # Embedded type, must be unwrapped
      element(attr_name, to_elements(attr_value, field.type))
    end
  end
end

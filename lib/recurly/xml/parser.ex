defprotocol Recurly.XML.Parser do
  @moduledoc """
  Protocol responsible for parsing xml into resources
  TODO - This still has some refactoring that can be done.
  """

  @doc """
  Parses an xml document into the given resource

  ## Parameters

  - `resource` empty resource struct to parse into
  - `xml_doc` String xml document
  - `list` boolean value, use true if top level xml is a list

  ## Examples

  ```
  xml_doc = "<account><account_code>myaccount</account></account>"
  account = Recurly.XML.Parser.parse(%Recurly.Account{}, xml_doc, false)
  ```
  """
  def parse(resource, xml_doc, list)
end

defimpl Recurly.XML.Parser, for: Any do
  import SweetXml
  alias Recurly.XML.Types
  alias Recurly.XML.Schema
  alias Recurly.XML.Field

  def parse(resource, xml_doc, true) do
    type = resource.__struct__
    path = to_char_list("//#{type.__resource_name__}")
    path = %SweetXpath{path: path, is_list: true}

    xml_doc
    |> xpath(path)
    |> Enum.map(fn xml_node ->
      parse(resource, xml_node, false)
    end)
  end
  def parse(resource, xml_doc, false) do
    type = resource.__struct__
    path = "/#{type.__resource_name__}/"

    xml_doc
    |> to_struct(type, path)
    |> insert_actions(xml_doc, path)
  end

  defp insert_actions(resource_struct, xml_doc, string_path) do
    path = %SweetXpath{path: to_char_list(string_path <> "a"), is_list: true}
    meta = resource_struct.__meta__

    actions =
      xml_doc
      |> xmap(
          actions: [
            path,
            name: ~x"./@name"s,
            href: ~x"./@href"s,
            method: ~x"./@method"s
          ]
        )
      |> Map.get(:actions)
      |> Enum.reduce(%{}, fn (action, acc) ->
        name = action |> Map.get(:name) |> String.to_atom
        method = action |> Map.get(:method) |> String.to_atom
        action = [method, Map.get(action, :href)]

        Map.put(acc, name, action)
      end)

    %{resource_struct | __meta__: Map.put(meta, :actions, actions)}
  end

  defp to_struct(xml_node, type, string_path) do
    schema = Schema.get(type)
    href_attr = parse_xml_attribute(xml_node, string_path, "href")
    path = %SweetXpath{path: to_char_list(string_path <> "*"), is_list: true}

    xml_node
    |> xpath(path)
    |> Enum.map(fn xml_node ->
      attr_name = xml_node |> xpath(~x"name(.)"s) |> String.to_atom
      field = Schema.find_field(schema, attr_name)
      xml_attributes = parse_xml_attributes(xml_node)
      {attr_name, xml_node, field, xml_attributes}
    end)
    |> Enum.map(&to_attribute/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.concat([{:__meta__, %{href: href_attr}}])
    |> from_map(type)
  end

  # Turns the xml node tuple into a resource attribute tuple
  defp to_attribute({_attr_name, _xml_node, nil, _xml_attrs}) do
    nil
  end
  defp to_attribute({attr_name, _xml_node, _field, %{"nil" => "nil"}}) do
    {attr_name, nil}
  end
  defp to_attribute({attr_name, _xml_node, field, xml_attrs = %{"childless" => true}}) do
    href = xml_attrs["href"]
    if href && String.length(href) > 0 do
      {
        attr_name,
        %Recurly.Association{
          href: href,
          resource_type: field.type,
          paginate: Field.pageable?(field)
        }
      }
    else
      # should probably raise an error
    end
  end
  defp to_attribute({attr_name, xml_node, field, %{"type" => "array"}}) do
    path = %SweetXpath{path: './*', is_list: true}

    resources =
      xml_node
      |> xpath(path)
      |> Enum.map(fn element_xml_node ->
        to_struct(element_xml_node, field.type, "./")
      end)

    {attr_name, resources}
  end
  defp to_attribute({attr_name, xml_node, %Field{type: :date_time}, _xml_attrs}) do
    val = text_value(xml_node)
    {attr_name, NaiveDateTime.from_iso8601!(val)}
  end
  defp to_attribute({attr_name, xml_node, %Field{type: :boolean}, _xml_attrs}) do
    val = text_value(xml_node) |> String.downcase
    case val do
      "true" -> {attr_name, true}
      "false" -> {attr_name, false}
      _ -> raise ArgumentError, message: "Invalid boolean value #{inspect({attr_name, val})}"
    end
  end
  defp to_attribute({attr_name, xml_node, field, xml_attrs}) do
    if Types.primitive?(field.type) do # Can be parsed and cast to a primitive type
      path = %SweetXpath{path: './text()', cast_to: field.type}
      value = xpath(xml_node, path)

      # TODO a better way to detect nil
      if value == "" do
        nil
      else
        {attr_name, value}
      end
    else # Is embedded and must parse out the children attributes
    #IO.inspect({attr_name, xml_node, field, xml_attrs})
      {attr_name, to_struct(xml_node, field.type, "./")}
    end
  end

  defp from_map(enum, type) do
    struct(type, enum)
  end

  # gives you a map of xml attributes and values for a node
  # will also have childless => true if node has no children
  defp parse_xml_attributes(xml_node) do
    attrs =
      ~w(href type nil)
      |> Enum.map(fn key ->
        {key, parse_xml_attribute(xml_node, "./", key)}
      end)
      |> Enum.into(%{})

    Map.put(attrs, "childless", xpath(xml_node, ~x"./*") == nil)
  end

  # parses a single xml attribute given a key
  defp parse_xml_attribute(xml_node, path, attribute_key) do
    text_value(xml_node, to_char_list("#{path}@#{attribute_key}"))
  end

  # Parses the text value of the xml node, optional path
  defp text_value(xml_node, path \\ './text()') do
    path = %SweetXpath{path: path, cast_to: :string}
    value = xpath(xml_node, path)

    case value do
      "" -> nil
      _  -> value
    end
  end
end

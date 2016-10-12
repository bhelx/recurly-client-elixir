defmodule MyDoubleEmbeddedResource do
  use Recurly.Resource

  schema :my_double_embedded_resource do
    field :name, :string
  end
end

defmodule MyEmbeddedResource do
  use Recurly.Resource

  schema :my_embedded_resource do
    field :name, :string
    field :a_double_embedded_resource, MyDoubleEmbeddedResource
  end
end

defmodule MyResource do
  use Recurly.Resource

  schema :my_resource do
    field :a_string, :string
    field :an_integer, :integer
    field :a_float, :float
    field :a_read_only, :string, read_only: true
    field :an_embedded_resource, MyEmbeddedResource
    field :an_array, MyEmbeddedResource, list: true
    field :a_boolean, :boolean
    field :a_date_time, :date_time
  end
end

defmodule Utils do
  alias Recurly.XML

  def compare_readable_fields(resource_type, fields) do
    readable =
      resource_type
      |> XML.Schema.get
      |> Map.get(:fields)
      |> Enum.map(fn field -> field.name end)
      |> Enum.sort

    readable == Enum.sort(fields)
  end

  def compare_writeable_fields(resource_type, fields) do
    writeable =
      resource_type
      |> XML.Schema.get
      |> XML.Schema.fields(:writeable)
      |> Enum.map(fn field -> field.name end)
      |> Enum.sort

    writeable == Enum.sort(fields)
  end
end

ExUnit.start()
Application.ensure_all_started(:bypass)

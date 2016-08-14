defmodule MyTrippleEmbeddedResource do
  use Recurly.Resource

  schema :my_tripple_embedded_resource do
    field :name, :string
  end
end

defmodule MyEmbeddedResource do
  use Recurly.Resource

  schema :my_embedded_resource do
    field :name, :string
    field :a_tripple_embedded_resource, MyTrippleEmbeddedResource
  end
end

defmodule MyResource do
  use Recurly.Resource

  schema :my_resource do
    field :a_string, :string
    field :an_integer, :integer
    field :a_float, :float
    field :an_embedded_resource, MyEmbeddedResource
    field :an_array, MyEmbeddedResource, array: true
    field :a_boolean, :boolean
    field :a_date_time, :date_time
  end
end

ExUnit.start()

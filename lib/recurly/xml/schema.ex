defmodule Recurly.XML.Schema do
  @moduledoc """
  Module responsible for handling schemas of the resources. Schemas are used for building
  the resource structs as well as marshalling and unmarshalling the xml. The syntax for
  defining schemas is similar to Ecto:

  ```
  defmodule MyResource do
    use Recurly.XML.Schema

    schema :my_resource do
      field :a_string, :string
      field :an_integer, :integer
      field :a_float, :float, read_only: true
    end
  end
  ```

  Calling `use Recurly.XML.Schema` adds two macros, `schema` and `field`. It also defines
  two functions on the module:

  - `__resource_name__/0`
  - `__schema__/0`

  The first returns the name of the resource `:my_schema`.
  The second returns the fields and their options.
  It also calls `defstruct` passing in the names of the fields to definte the type.
  """

  defstruct [:fields, :resource_type]

  alias Recurly.XML.Field

  @doc false
  defmacro __using__(_) do
    quote do
      import Recurly.XML.Schema, only: :macros
      Module.register_attribute(__MODULE__, :schema_fields, accumulate: true)
    end
  end

  @doc """
  Defines the schema for this resource
  """
  defmacro schema(resource_name, do: block) do
    quote do
      try do
        unquote(block)
      after
        :ok
      end

      fields = @schema_fields |> Enum.reverse

      Module.eval_quoted __ENV__, [
        Recurly.XML.Schema.__defstruct__(fields),
        Recurly.XML.Schema.__defschema__(fields),
        Recurly.XML.Schema.__defname__(unquote(resource_name))
      ]
    end
  end

  @doc """
  Defines a field in the schema
  """
  defmacro field(name, type, opts \\ []) do
    quote do
      Recurly.XML.Schema.__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  def __defname__(name) do
    quote do
      @doc false
      def __resource_name__ do
        unquote(name)
      end
    end
  end

  def __defstruct__(fields) do
    quote do
      keys = Enum.map(unquote(fields), fn kwl ->
        Keyword.get(kwl, :name)
      end)
      defstruct keys ++ [:__meta__]
    end
  end

  # TODO probably a more efficient way to do this?
  def __defschema__(fields) do
    quote do
      @doc false
      def __schema__ do
        # Convert the raw keyword lists to Fields
        fields =
          unquote(fields)
          |> Enum.map(fn field ->
            %Field{
              name: Keyword.get(field, :name),
              type: Keyword.get(field, :type),
              opts: Keyword.get(field, :opts)
            }
          end)

        %Recurly.XML.Schema{
          fields: fields,
          resource_type: __MODULE__
        }
      end
    end
  end

  def __field__(mod, name, type, opts) do
    Module.put_attribute(mod, :schema_fields, [name: name, type: type, opts: opts])
  end

  # Public Interface

  def get(resource_type) do
    resource_type.__schema__
  end

  def fields(schema, :writeable) do
    schema
    |> Map.get(:fields, [])
    |> Enum.map(fn field ->
      unless Keyword.get(field.opts, :read_only) do
        field
      end
    end)
  end

  def find_field(schema, name) do
    schema
    |> Map.get(:fields)
    |> Enum.find(fn field -> field.name == name end)
  end
end

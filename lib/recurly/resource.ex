defmodule Recurly.Resource do
  @moduledoc """
  Module responsible for handling restful resources and actions.
  Mostly for internal use. API unstable.
  """

  alias Recurly.API
  alias Recurly.XML

  @doc false
  defmacro __using__(_) do
    quote do
      @derive Recurly.XML.Parser
      use Recurly.XML.Schema
    end
  end

  @doc """
  Returns a list of resources at the given endpoint

  ## Parameters

    - `resource` Recurly.Resource struct to parse result into
    - `path` String path to the resource
    - `options` Keyword list of GET params

  ## Examples

  ```
  case Recurly.Resource.list(%Recurly.Account{}, "/accounts", state: "subscriber") do
    {:ok, accounts} ->
      # list of accounts
    {:error, error} ->
      # There was an error
  end
  ```
  """
  def list(resource, path, options) do
    case API.make_request(:get, path, "", params: options) do
      {:ok, xml_string} ->
        {:ok, XML.Parser.parse(resource, xml_string, true)}
      err ->
        err
    end
  end

  @doc """
  Finds and parses a resource given a path

  ## Parameters

  `Recurly.Resource.find/2` takes a resource and a path:

    - `resource` Recurly.Resource struct to parse result into
    - `path` String path to the resource

  `Recurly.Resource.find/1` takes an association:

    - `association` `Recurly.Association` struct with paginate: false

  ## Examples

  ```
  case Recurly.Resource.find(%Recurly.Account{}, "/accounts/account123") do
    {:ok, account} ->
      # successfully found account
    {:error, error} ->
      # There was an error
  end
  ```
  """
  def find(resource, path) do
    case API.make_request(:get, path) do
      {:ok, xml_string} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end


  @doc """
  Finds and parses a resource given an association

  ## Parameters

  - `association` `Recurly.Association` struct where paginate == false

  ## Examples

  ```
  {:ok, account} = Recurly.Account.find("myaccountcode")

  # Suppose we have an account and want to fetch the billing info association
  case Recurly.Resource.find(account.billing_info) do
    {:ok, billing_info} ->
      # successfully found the billing_info
    {:error, error} ->
      # There was an error
  end

  # It will explode if we try to use a pageable association
  Recurly.Resource.find(account.transactions)
  #=> crashes with argument error because paginate == true
  ```
  """
  def find(association = %Recurly.Association{paginate: false}) do
    resource = struct(association.resource_type)
    path = association.href
    find(resource, path)
  end
  def find(association = %Recurly.Association{paginate: true}) do
    raise ArgumentError, message: "association must be a singleton but paginate == true => #{inspect association}"
  end

  @doc """
  Creates a resource on the server and returns a resource struct.

  ## Parameters

    - `resource` empty resource struct with the type of the expected return resource
    - `changset` Keyword list changeset representing the creation data
    - `path` String path to the creation endpoint

  ## Examples

  ```
    changeset = [
      account_code: "myaccountcode"
    ]

    case Recurly.Resource.create(%Recurly.Account{}, changeset, "/accounts/") do
      {:ok, account} ->
        # successfully created
      {:error, error} ->
        # There was an error
    end
  ```
  """
  def create(resource, changeset, path) do
    resource_type = resource.__struct__
    xml_body = XML.Builder.generate(changeset, resource_type)

    case API.make_request(:post, path, xml_body) do
      {:ok, xml_string} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end

  def update(resource, changeset, path \\ nil) do
    type = resource.__struct__
    path = if path, do: path, else: location(resource)
    changeset = Map.new(changeset)

    # TODO - should adjust attributes function
    # to accept options (reject nils for instance)
    # maybe also change it to return a map
    xml_body =
      # resource
      # |> Recurly.Resource.attributes
      # |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      # |> Map.new
      # |> Map.merge(changeset)
      changeset
      |> Map.new
      |> XML.Builder.generate(type)

    case API.make_request(:put, path, xml_body) do
      {:ok, xml_string} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end

  @doc """
  Gives us the attributes of a resource without all the metadata.

  ## Parameters

    - `resource` Resource struct with some attributes

  """
  def attributes(resource) do
    Map.drop(resource, [:__struct__, :__meta__])
  end

  @doc """
  Gives us fully qualified location of the persisted resource.

  ## Parameters

    - `resource` Resource struct representing a persisted resource

  """
  def location(resource) do
    resource.__meta__.href
  end

  @doc """
  Returns an map of actions keyed by action name

  ## Parameters

  - `resource` Recurly.Resource struct

  """
  def actions(resource) do
    resource.__meta__.actions
  end

  @doc """
  Returns an action on a resource given the action name

  ## Parameters

  - `resource` Recurly.Resource struct
  - `action_name` Atom of the action name

  ## Examples

  ```
  Recurly.Resource.action(subscription, :cancel)
  #=> [:put, "https://your-subsdomain.recurly.com/v2/subscriptions/36d81d1e79995b0b4c7df3419aa1c2f5/cancel"]
  ```
  """
  def action(resource, action_name) when is_atom(action_name) do
    resource
    |> actions
    |> Map.get(action_name)
  end

  @doc """
  Performs and action on a resource. Actions can be found in the &lt;a&gt; tags of the xml.
  It follows the same response pattern as `Recurly.API.make_request/5`

  ## Parameters

    - `resource` Resource struct representing a persisted resource
    - `action_name` Atom of the action name

  ## Examples

  ```
  case Recurly.Resource.perform_action(subscription, :cancel) do
    {:ok, subscription} ->
      # sucessfully canceled the subscription
    {:error, error} ->
      # error happened
  end
  ```
  """
  def perform_action(resource, action_name) do
    resource_action = action(resource, action_name)

    case apply(&API.make_request/2, resource_action) do
      {:ok, xml_string} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end

  # @doc false
  # def from_changeset(changeset, resource_type) do
  #   schema = XML.Schema.fields(resource_type)

  #   changeset =
  #     changeset
  #     |> Enum.map(fn {attr_name, attr_value} ->
  #       type = Keyword.get(schema, attr_name)
  #       if type && attr_value do
  #         if XML.Types.primitive?(type) do
  #           {attr_name, attr_value}
  #         else
  #           {attr_name, from_changeset(attr_value, type)}
  #         end
  #       end
  #     end)
  #     |> Enum.reject(&is_nil/1)

  #   struct(resource_type, changeset)
  # end
end

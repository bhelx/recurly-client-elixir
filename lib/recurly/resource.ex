defmodule Recurly.Resource do
  @moduledoc """
  Module responsible for handling restful resources and actions.
  Mostly for internal use. API unstable.
  """

  alias Recurly.API
  alias Recurly.XML
  alias Recurly.{Resource,Page,Association}

  @doc false
  defmacro __using__(_) do
    quote do
      @derive Recurly.XML.Parser
      use Recurly.XML.Schema
    end
  end

  @doc """
  Returns a `Recurly.Page` at the given endpoint. You will probably not
  want to use this directly and instead use `Recurly.Resource.stream/3`.

  ## Parameters

    - `resource` Recurly.Resource struct to parse result into
    - `path` String path to the resource
    - `options` the request options. See options in the
        [pagination section](https://dev.recurly.com/docs/pagination)
        of the docs for possible values.

  ## Examples

  ```
  case Recurly.Resource.list(%Recurly.Account{}, "/accounts", state: "subscriber") do
    {:ok, page} ->
      # a recurly page
    {:error, error} ->
      # There was an error
  end
  ```
  """
  @spec list(struct, String.t, keyword) :: {:ok, Page.t} | {:error, any}
  def list(resource, path, options) do
    case API.make_request(:get, path, "", params: options) do
      {:ok, xml_string, headers} ->
        resources = XML.Parser.parse(resource, xml_string, true)
        page = Page.from_response(resource, resources, headers)
        {:ok, page}
      err ->
        err
    end
  end

  @doc """
  Creates a stream from a `Recurly.Association`. See `Recurly.Resource.stream/3`.
  """
  @spec stream(Association.t, keyword) :: Enumerable.t
  def stream(association = %Association{paginate: true}, options \\ []) do
    association
    |> Map.get(:resource_type)
    |> Page.new(association.href, options)
    |> Page.to_stream
  end

  @doc """
  Creates a stream of resources given a type,
  an endpoint, and request options.

  A resource stream behaves the way any elixir `Stream` would behave.
  Streams are composable and lazy. We'll try to create some trivial examples
  here but what you can accomplish with streams is pretty limitless.

  TODO - need more examples, need error handling

  ## Parameters

  - `resource_type` the resource type to parse
  - `endpoint` the list path for this stream of pages
  - `options` the request options. See options in the
      [pagination section](https://dev.recurly.com/docs/pagination)
      of the docs.

  ## Examples

  You should use the shortcut on the module of the resource you are streaming such as
  `Recurly.Subscription.stream/1` to create the stream. This function is mostly
  for internal use, but these examples will show Resource's stream function.

  ```
  alias Recurly.Resource
  alias Recurly.Subscription
  alias Recurly.Account

  # Suppose we want the uuids of the first 70 active subscription in order of creation (newest to oldest)
  options = [state: :active, order: :desc, sort: :created_at]

  stream = Resource.stream(Subscription, "/subscriptions", options)
  # stream = Subscription.stream(options) # use this shortcut instead

  uuids =
    stream
    |> Stream.map(&(Map.get(&1, :uuid)))
    |> Enum.take(70)

  # uuids => ["376e7209ee28de6b611f7b49df847539", "376e71e42b254873f550a749789dbaaa", ...] # 68 more

  # Since the default page size is 50, we had to fetch 2 pages.
  # This, however, was abstracted away from you.

  # You can also turn associations into streams as long as their `paginate` attribute
  # is true. Consider the example of getting the uuids of each transaction on an account

  {:ok, account} = Account.find("myaccountcode")

  uuids =
    account
    |> Map.get(:transactions)
    |> Resource.stream
    |> Enum.map(fn tr -> tr.uuid end)

  # uuids => ["37f6aa1eae4657c0d8b430455fb6dcb6", "6bcd6bf554034b8d0c7564eae1aa6f73", ...]
  ```
  """
  @spec stream(atom, String.t, keyword) :: Enumerable.t
  def stream(resource_type, endpoint, options) do
    resource_type
    |> Page.new(endpoint, options)
    |> Page.to_stream
  end

  @doc """
  Gives the count of records returned given a path and options

  ## Parameters

  - `path` the url path
  - `options` the request options. See options in the
      [pagination section](https://dev.recurly.com/docs/pagination)
      of the docs.

  ## Examples

  ```
  # suppose we want to count all subscriptions
  case Recurly.Resource.count("/subscriptions", []) do
    {:ok, count} ->
      # count => 176 (or some integer)
    {:error, err} ->
      # error occurred
  end

  # or maybe we wan to count just active subscriptions
  case Recurly.Resource.count("/subscriptions", state: :active) do
    {:ok, count} ->
      # count => 83 (or some integer)
    {:error, err} ->
      # error occurred
  end
  ```
  """
  @spec count(String.t, keyword) :: {:ok, integer} | {:error, any}
  def count(path, options) do
    case API.make_request(:head, path, "", params: options) do
      {:ok, _xml_string, headers} ->
        {num_records, _} = Integer.parse(headers["X-Records"])
        {:ok, num_records}
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
  @spec find(struct, String.t) :: {:ok, struct} | {:error, any}
  def find(resource, path) do
    case API.make_request(:get, path) do
      {:ok, xml_string, _headers} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end

  @doc """
  Gives the first resource returned given a path and options

  ## Parameters

  - `resource` resource to parse into
  - `path` the url path
  - `options` the request options. See options in the
      [pagination section](https://dev.recurly.com/docs/pagination)
      of the docs.

  ## Examples

  ```
  alias Recurly.Resource
  alias Recurly.Subscription

  # suppose we want the latest, active subscription
  case Resource.first(%Subscription{}, "/subscriptions", state: :active) do
    {:ok, subscription} ->
      # subscription => the newest active subscription
    {:error, err} ->
      # error occurred
  end

  # or maybe want the oldest, active subscription
  case Resource.first(%Subscription{}, "/subscriptions", state: :active, order: :asc) do
    {:ok, subscription} ->
      # subscription => the oldest active subscription
    {:error, err} ->
      # error occurred
  end
  ```
  """
  @spec first(struct, String.t, keyword) :: {:ok, struct} | {:error, any}
  def first(resource, path, options) do
    options = Keyword.merge(options, per_page: 1)
    case Recurly.Resource.list(resource, path, options) do
      {:ok, page} ->
        first_resource = page |> Map.get(:resources) |> List.first
        {:ok, first_resource}
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
      {:ok, xml_string, _headers} ->
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
      {:ok, xml_string, _headers} ->
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
      {:ok, xml_string, _headers} ->
        {:ok, XML.Parser.parse(resource, xml_string, false)}
      err ->
        err
    end
  end
end

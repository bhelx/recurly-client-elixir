defmodule Recurly.Subscription do
  @moduledoc """
  Module for handling subscriptions in Recurly.
  See the [developer docs on subscriptions](https://dev.recurly.com/docs/list-subscriptions)
  for more details

  TODO implement postpone and reactivate
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "/subscriptions"

  schema :subscription do
    field :account, Recurly.Account
    field :activated_at, :date_time
    field :canceled_at, :date_time
    field :currency
    field :current_period_started_at, :date_time
    field :expires_at, :date_time
    field :plan, Recurly.Plan
    field :plan_code
    field :quantity, :integer
    field :state, :string, read_only: true
    field :subscription_add_ons, Recurly.SubscriptionAddOn, list: true
    field :tax_in_cents, :integer
    field :tax_rate, :float
    field :tax_region
    field :tax_type
    field :unit_amount_in_cents, :integer
    field :updated_at, :date_time
    field :uuid
  end

  @doc """
  Creates a stream of subscriptions given some options.

  ## Parameters

  - `options` Keyword list of the request options. See options in the
      [subscription list section](https://dev.recurly.com/docs/list-subscriptions)
      of the docs.

  ## Examples

  See `Recurly.Resource.stream/3` for more detailed examples of
  working with resource streams.

  ```
  # stream of active subscriptions sorted from most recently
  # updated to least recently updated
  stream = Recurly.Subscription.stream(state: :active, sort: :updated_at)
  ```
  """
  def stream(options \\ []) do
    Recurly.Resource.stream(Recurly.Subscription, @endpoint, options)
  end

  @doc """
  Gives the count of subscriptions on the server given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [subscription list section](https://dev.recurly.com/docs/list-subscriptions)
      of the docs.

  # Examples

  ```
  # suppose we want to count all subscriptions
  case Recurly.Subscription.count() do
    {:ok, count} ->
      # count => 176 (or some integer)
    {:err, err} ->
      # error occurred
  end

  # or maybe we wan to count just active subscriptions
  case Recurly.Subscription.count(state: :active) do
    {:ok, count} ->
      # count => 83 (or some integer)
    {:err, err} ->
      # error occurred
  end
  ```
  """
  def count(options \\ []) do
    Recurly.Resource.count(@endpoint, options)
  end

  @doc """
  Gives the first subscription returned given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [subscription list section](https://dev.recurly.com/docs/list-subscriptions)
      of the docs.

  # Examples

  ```
  # suppose we want the latest, active subscription
  case Recurly.Subscription.first(state: :active) do
    {:ok, subscription} ->
      # subscription => the newest active subscription
    {:err, err} ->
      # error occurred
  end

  # or maybe want the oldest, active subscription
  case Recurly.Subscription.first(state: :active, order: :asc) do
    {:ok, subscription} ->
      # subscription => the oldest active subscription
    {:err, err} ->
      # error occurred
  end
  ```
  """
  def first(options \\ []) do
    Recurly.Resource.first(%Recurly.Subscription{}, @endpoint, options)
  end

  @doc """
  Finds a subscription given a subscription uuid. Returns the subscription or an error.

  ## Parameters

  - `uuid` String subscription uuid

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Subscription.find("36ce107b00244abd107f4e4397a19e95") do
    {:ok, subscription} ->
      # Found the subscription
    {:error, %NotFoundError{}} ->
      # 404 subscription was not found
  end
  ```
  """
  def find(uuid) do
    Resource.find(%Recurly.Subscription{}, path(uuid))
  end

  @doc """
  Creates a subscription from a changeset. Supports nesting the `account`.

  ## Parameters

  - `changeset` Keyword list changeset

  ## Examples

  ```
  alias Recurly.ValidationError

  changeset = [
    plan_code: "gold",
    currency: "USD",
    account: [
      account_code: "b6f5783",
      email: "verena@example.com",
      first_name: "Verena",
      last_name: "Example",
      billing_info: [
        number: "4111-1111-1111-1111",
        month: 12,
        year: 2019,
        verification_value: "123",
        address1: "400 Alabama St",
        city: "San Francisco",
        state: "CA",
        country: "US",
        zip: "94110"
      ]
    ]
  ]

  case Recurly.Subscription.create(changeset) do
    {:ok, subscription} ->
      # created the subscription
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset) do
    Resource.create(%Recurly.Subscription{}, changeset, @endpoint)
  end

  @doc """
  Cancels a given subscription. See [docs](https://dev.recurly.com/docs/cancel-subscription) on
  canceling a subscription.

  TODO more docs
  """
  def cancel(subscription = %Recurly.Subscription{}) do
    Resource.perform_action(subscription, :cancel)
  end

  @doc """
  Terminates a given subscription. See [docs](https://dev.recurly.com/docs/terminate-subscription) on
  terminating a subscription.

  TODO more docs
  """
  def terminate(subscription = %Recurly.Subscription{}) do
    Resource.perform_action(subscription, :terminate)
  end

  @doc """
  Generates the path to a subscription given the uuid

  ## Parameters

    - `uuid` String subscription uuid

  """
  def path(uuid) do
    Path.join(@endpoint, uuid)
  end
end

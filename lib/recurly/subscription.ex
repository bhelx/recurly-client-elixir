defmodule Recurly.Subscription do
  @moduledoc """
  Module for handling subscriptions in Recurly.
  See the [developer docs on subscriptions](https://dev.recurly.com/docs/list-subscriptions)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "/subscriptions"

  schema :subscription do
    field :account, Recurly.Account
    field :currency
    field :plan, Recurly.Plan
    field :plan_code
    field :quantity, :integer
    field :state, :string, read_only: true
    field :subscription_add_ons, Recurly.SubscriptionAddOn, array: true
    field :tax_in_cents, :integer
    field :tax_rate, :float
    field :tax_region
    field :tax_type
    field :unit_amount_in_cents, :integer
    field :uuid
  end

  @doc """
  Lists all the subscriptions. See [the subscriptions dev docs](https://dev.recurly.com/docs/list-subscriptions) for more details.

  ## Parameters

  - `options` Keyword list of GET params

  ## Examples

  ```
  case Recurly.Subscription.list(state: "active") do
    {:ok, subscriptions} ->
      # list of active subscriptions
    {:error, error} ->
      # error happened
  end
  ```
  """
  def list(options \\ []) do
    Resource.list(%Recurly.Subscription{}, @endpoint, options)
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

  def cancel(subscription = %Recurly.Subscription{}) do
    Resource.perform_action(subscription, :cancel)
  end

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

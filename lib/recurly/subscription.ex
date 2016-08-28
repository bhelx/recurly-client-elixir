defmodule Recurly.Subscription do
  @moduledoc """
  Module for handling subscriptions in Recurly.
  See the [developer docs on subscriptions](https://dev.recurly.com/docs/list-subscriptions)
  for more details

  TODO implement postpone and reactivate
  """
  use Recurly.Resource
  alias Recurly.{Resource,Subscription,Account,Plan,SubscriptionAddOn}

  @endpoint "/subscriptions"

  @type t :: %__MODULE__{
    account:                    Account.t,
    activated_at:               NaiveDateTime.t,
    canceled_at:                NaiveDateTime.t,
    currency:                   String.t,
    current_period_started_at:  NaiveDateTime.t,
    expires_at:                 NaiveDateTime.t,
    bank_account_authorized_at: String.t,
    bulk:                       boolean,
    coupon_code:                String.t,
    collection_method:          String.t,
    customer_notes:             String.t,
    first_renewal_date:         NaiveDateTime.t,
    net_terms:                  String.t,
    plan:                       Plan.t,
    plan_code:                  String.t,
    po_number:                  String.t,
    quantity:                   integer,
    state:                      String.t,
    subscription_add_ons:       list(SubscriptionAddOn.t),
    starts_at:                  NaiveDateTime.t,
    tax_in_cents:               integer,
    tax_rate:                   float,
    tax_region:                 String.t,
    tax_type:                   String.t,
    terms_and_conditions:       String.t,
    total_billing_cycles:       String.t,
    trial_ends_at:              NaiveDateTime.t,
    unit_amount_in_cents:       integer,
    updated_at:                 NaiveDateTime.t,
    uuid:                       String.t,
    vat_reverse_charge_notes:   String.t,
    revenue_schedule_type:      String.t,
  }

  schema :subscription do
    field :account,                    Account
    field :activated_at,               :date_time, read_only: true
    field :canceled_at,                :date_time, read_only: true
    field :currency,                   :string
    field :current_period_started_at,  :date_time
    field :expires_at,                 :date_time, read_only: true
    field :bank_account_authorized_at, :string
    field :bulk,                       :boolean
    field :coupon_code,                :string
    field :collection_method,          :string
    field :customer_notes,             :string
    field :first_renewal_date,         :date_time
    field :net_terms,                  :string
    field :plan,                       Plan
    field :plan_code,                  :string
    field :po_number,                  :string
    field :quantity,                   :integer
    field :state,                      :string, read_only: true
    field :subscription_add_ons,       SubscriptionAddOn, list: true
    field :starts_at,                  :date_time
    field :tax_in_cents,               :integer
    field :tax_rate,                   :float
    field :tax_region,                 :string
    field :tax_type,                   :string
    field :terms_and_conditions,       :string
    field :total_billing_cycles,       :string
    field :trial_ends_at,              :date_time
    field :unit_amount_in_cents,       :integer
    field :updated_at,                 :date_time, read_only: true
    field :uuid,                       :string
    field :vat_reverse_charge_notes,   :string
    field :revenue_schedule_type,      :string
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
  @spec stream(keyword) :: Enumerable.t
  def stream(options \\ []) do
    Resource.stream(Subscription, @endpoint, options)
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
    {:error, err} ->
      # error occurred
  end

  # or maybe we wan to count just active subscriptions
  case Recurly.Subscription.count(state: :active) do
    {:ok, count} ->
      # count => 83 (or some integer)
    {:error, err} ->
      # error occurred
  end
  ```
  """
  @spec count(keyword) :: {:ok, integer} | {:error, any}
  def count(options \\ []) do
    Resource.count(@endpoint, options)
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
    {:error, err} ->
      # error occurred
  end

  # or maybe want the oldest, active subscription
  case Recurly.Subscription.first(state: :active, order: :asc) do
    {:ok, subscription} ->
      # subscription => the oldest active subscription
    {:error, err} ->
      # error occurred
  end
  ```
  """
  @spec first(keyword) :: {:ok, Subscription.t} | {:error, any}
  def first(options \\ []) do
    Resource.first(%Subscription{}, @endpoint, options)
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
  @spec first(keyword) :: {:ok, Subscription.t} | {:error, any}
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
  @spec create(keyword) :: {:ok, Subscription.t} | {:error, any}
  def create(changeset) do
    Resource.create(%Subscription{}, changeset, @endpoint)
  end

  @doc """
  Cancels a given subscription. See [docs](https://dev.recurly.com/docs/cancel-subscription) on
  canceling a subscription.

  TODO more docs
  """
  @spec cancel(Subscription.t) :: {:ok, Subscription.t} | {:error, any}
  def cancel(subscription = %Subscription{}) do
    Resource.perform_action(subscription, :cancel)
  end

  @doc """
  Terminates a given subscription. See [docs](https://dev.recurly.com/docs/terminate-subscription) on
  terminating a subscription.

  TODO more docs
  """
  @spec terminate(Subscription.t) :: {:ok, Subscription.t} | {:error, any}
  def terminate(subscription = %Subscription{}) do
    Resource.perform_action(subscription, :terminate)
  end

  @doc """
  Generates the path to a subscription given the uuid

  ## Parameters

    - `uuid` String subscription uuid

  """
  @spec path(String.t) :: String.t
  def path(uuid) do
    Path.join(@endpoint, uuid)
  end
end

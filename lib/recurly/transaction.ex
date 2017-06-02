defmodule Recurly.Transaction do
  @moduledoc """
  Module for handling transactions in Recurly.
  See the [developer docs on transactions](https://dev.recurly.com/docs/list-transactions)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource,Transaction,TransactionDetails,Account,Invoice,Subscription}

  @endpoint "/transactions"

  schema :transaction do
    field :account,               Account, read_only: true
    field :action,                :string
    field :amount_in_cents,       :integer
    field :currency,              :string
    field :details,               TransactionDetails, read_only: true
    field :invoice,               Invoice, read_only: true
    field :ip_address,            :string
    field :original_transaction,  Transaction, read_only: true
    field :payment_method,        :string
    field :recurring_type,        :boolean
    field :reference,             :string
    field :refundable_type,       :boolean
    field :source,                :string
    field :subscription,          Subscription, read_only: true
    field :tax_in_cents,          :integer
    field :test_type,             :boolean
    field :transaction_code,      :string
    field :uuid,                  :string
    field :voidable_type,         :boolean
  end

  @doc """
  Creates a stream of transactions given some options.

  ## Parameters

  - `options` Keyword list of the request options. See options in the
      [transaction list section](https://dev.recurly.com/docs/list-transactions)
      of the docs.

  ## Examples

  See `Recurly.Resource.stream/3` for more detailed examples of
  working with resource streams.

  ```
  # stream of successful transactions sorted from most recently
  # created to least recently created
  stream = Recurly.Transaction.stream(state: :successful, sort: :created_at)
  ```
  """
  def stream(options \\ []) do
    Resource.stream(Transaction, @endpoint, options)
  end

  @doc """
  Finds an transaction given a transaction uuid. Returns the transaction or an error.

  ## Parameters

  - `uuid` String transaction uuid

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Transaction.find("ialskdjaldkjsaldkjas") do
    {:ok, transaction} ->
      # Found the transaction
    {:error, %NotFoundError{}} ->
      # 404 transaction was not found
  end
  ```
  """
  def find(uuid) do
    Resource.find(%Transaction{}, path(uuid))
  end

  @doc """
  Creates an transaction from a changeset. Supports nesting the `billing_info`

  ## Parameters

  - `changeset` Keyword list changeset

  ## Examples

  ```
  alias Recurly.ValidationError

  case Recurly.Transaction.create(transaction_code: "mytransactioncode") do
    {:ok, transaction} ->
      # created the transaction
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset) do
    Resource.create(%Transaction{}, changeset, @endpoint)
  end

  @doc """
  Updates an transaction from a changeset

  ## Parameters

  - `transaction` transaction resource struct
  - `changeset` Keyword list changeset representing the updates

  ## Examples

  ```
  alias Recurly.ValidationError

  changes = [
    first_name: "Benjamin",
    last_name: nil
  ]

  case Recurly.transaction.update(transaction, changes) do
    {:ok, transaction} ->
      # the updated transaction
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def update(transaction = %Transaction{}, changeset) do
    Resource.update(transaction, changeset)
  end

  @doc """
  Generates the path to an transaction given the transaction code

  ## Parameters

    - `transaction_code` String transaction code

  """
  def path(transaction_code) do
    Path.join(@endpoint, transaction_code)
  end
end

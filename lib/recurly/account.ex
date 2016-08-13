defmodule Recurly.Account do
  @moduledoc """
  Module for handling accounts in Recurly.
  See the [developer docs on accounts](https://dev.recurly.com/docs/account-object)
  for more details
  """
  use Recurly.Resource
  alias Recurly.Resource

  @endpoint "/accounts"

  schema :account do
    field :accept_language
    field :account_code
    field :address, Recurly.Address
    field :billing_info, Recurly.BillingInfo
    field :cc_emails
    field :closed_at, :date_time
    field :company_name, :string
    field :created_at, :date_time
    field :email
    field :entity_use_code
    field :first_name
    field :last_name
    field :state, :string, read_only: true
    field :tax_exempt, :boolean
    field :transactions, Recurly.Transaction, paginate: true
    field :updated_at, :date_time
    field :username
    field :vat_number
  end

  @doc """
  Creates a stream of accounts given some options.

  ## Parameters

  - `options` Keyword list of the request options. See options in the
      [account list section](https://dev.recurly.com/docs/list-accounts)
      of the docs.

  ## Examples

  See `Recurly.Resource.stream/3` for more detailed examples of
  working with resource streams.

  ```
  # stream of past due accounts sorted from most recently
  # updated to least recently updated
  stream = Recurly.Account.stream(state: :past_due, sort: :updated_at)
  ```
  """
  def stream(options \\ []) do
    Recurly.Resource.stream(Recurly.Account, @endpoint, options)
  end

  @doc """
  Gives the count of accounts on the server given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [account list section](https://dev.recurly.com/docs/list-accounts)
      of the docs.

  # Examples

  ```
  # suppose we want to count all accounts
  case Recurly.Account.count() do
    {:ok, count} ->
      # count => 176 (or some integer)
    {:err, err} ->
      # error occurred
  end

  # or maybe we wan to count just past due accounts
  case Recurly.Account.count(state: :past_due) do
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
  Gives the first account returned given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [account list section](https://dev.recurly.com/docs/list-accounts)
      of the docs.

  # Examples

  ```
  # suppose we want the latest, active account
  case Recurly.Account.first(state: :active) do
    {:ok, account} ->
      # account => the newest active account
    {:err, err} ->
      # error occurred
  end

  # or maybe want the oldest, active account
  case Recurly.Account.first(state: :active, order: :asc) do
    {:ok, account} ->
      # account => the oldest active account
    {:err, err} ->
      # error occurred
  end
  ```
  """
  def first(options \\ []) do
    Recurly.Resource.first(%Recurly.Account{}, @endpoint, options)
  end

  @doc """
  Finds an account given an account code. Returns the account or an error.

  ## Parameters

  - `account_code` String account code

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Account.find("myaccountcode") do
    {:ok, account} ->
      # Found the account
    {:error, %NotFoundError{}} ->
      # 404 account was not found
  end
  ```
  """
  def find(account_code) do
    Resource.find(%Recurly.Account{}, path(account_code))
  end

  @doc """
  Creates an account from a changeset. Supports nesting the `billing_info`

  ## Parameters

  - `changeset` Keyword list changeset

  ## Examples

  ```
  alias Recurly.ValidationError

  case Recurly.Account.create(account_code: "myaccountcode") do
    {:ok, account} ->
      # created the account
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def create(changeset) do
    Resource.create(%Recurly.Account{}, changeset, @endpoint)
  end

  @doc """
  Updates an account from a changeset

  ## Parameters

  - `account` account resource struct
  - `changeset` Keyword list changeset representing the updates

  ## Examples

  ```
  alias Recurly.ValidationError

  changeset = [
    first_name: "Benjamin",
    last_name: nil
  ]

  case Recurly.Account.update(account, changeset) do
    {:ok, account} ->
      # the updated account
    {:error, %ValidationError{errors: errors}} ->
      # will give you a list of validation errors
  end
  ```
  """
  def update(account = %Recurly.Account{}, changeset) do
    Resource.update(account, changeset)
  end

  @doc """
  Generates the path to an account given the account code

  ## Parameters

    - `account_code` String account code

  """
  def path(account_code) do
    Path.join(@endpoint, account_code)
  end
end

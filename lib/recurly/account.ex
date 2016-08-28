defmodule Recurly.Account do
  @moduledoc """
  Module for handling accounts in Recurly.
  See the [developer docs on accounts](https://dev.recurly.com/docs/account-object)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource, Account, Address, Association, BillingInfo, Transaction}

  @endpoint "/accounts"

  @type t :: %__MODULE__{
    accept_language: String.t,
    account_code:    String.t,
    address:         Address.t,
    billing_info:    Association.t,
    cc_emails:       String.t,
    closed_at:       NaiveDateTime.t,
    company_name:    String.t,
    created_at:      NaiveDateTime.t,
    email:           String.t,
    entity_use_code: String.t,
    first_name:      String.t,
    last_name:       String.t,
    state:           String.t,
    tax_exempt:      boolean,
    transactions:    Association.t,
    updated_at:      NaiveDateTime.t,
    username:        String.t,
    vat_number:      String.t,
  }

  schema :account do
    field :accept_language, :string
    field :account_code,    :string
    field :address,         Address
    field :billing_info,    BillingInfo
    field :cc_emails,       :string
    field :closed_at,       :date_time, read_only: true
    field :company_name,    :string
    field :created_at,      :date_time, read_only: true
    field :email,           :string
    field :entity_use_code, :string
    field :first_name,      :string
    field :last_name,       :string
    field :state,           :string, read_only: true
    field :tax_exempt,      :boolean
    field :transactions,    Transaction, list: true
    field :updated_at,      :date_time, read_only: true
    field :username,        :string
    field :vat_number,      :string
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
  @spec stream(keyword) :: Enumerable.t
  def stream(options \\ []) do
    Resource.stream(Account, @endpoint, options)
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
    {:error, err} ->
      # error occurred
  end

  # or maybe we wan to count just past due accounts
  case Recurly.Account.count(state: :past_due) do
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
    {:error, err} ->
      # error occurred
  end

  # or maybe want the oldest, active account
  case Recurly.Account.first(state: :active, order: :asc) do
    {:ok, account} ->
      # account => the oldest active account
    {:error, err} ->
      # error occurred
  end
  ```
  """
  @spec first(keyword()) :: {:ok, Account.t} | {:error, any}
  def first(options \\ []) do
    Resource.first(%Account{}, @endpoint, options)
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
  @spec find(String.t) :: {:ok, Account.t} | {:error, any}
  def find(account_code) do
    Resource.find(%Account{}, path(account_code))
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
  @spec create(keyword) :: {:ok, Account.t} | {:error, any}
  def create(changeset) do
    Resource.create(%Account{}, changeset, @endpoint)
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
  @spec update(Account.t, keyword) :: {:ok, Account.t} | {:error, any}
  def update(account = %Account{}, changeset) do
    Resource.update(account, changeset)
  end

  @doc """
  Generates the path to an account given the account code

  ## Parameters

    - `account_code` String account code

  """
  @spec path(String.t) :: String.t
  def path(account_code) do
    Path.join(@endpoint, account_code)
  end
end

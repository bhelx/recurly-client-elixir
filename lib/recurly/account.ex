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
    field :account_code
    field :address, Recurly.Address
    field :billing_info, Recurly.BillingInfo
    field :cc_emails
    field :company_name, :string
    field :email
    field :first_name
    field :last_name
    field :state, :string, read_only: true
    field :tax_exempt, :boolean
    field :transactions, Recurly.Transaction, paginate: true
    field :username
    field :vat_number
  end

  @doc """
  Lists all the accounts. See [the accounts dev docs](https://dev.recurly.com/docs/list-accounts) for more details.

  ## Parameters

  - `options` Keyword list of GET params

  ## Examples

  ```
  case Recurly.Account.list(state: "subscriber") do
    {:ok, accounts} ->
      # list of subscriber accounts
    {:error, error} ->
      # error happened
  end
  ```
  """
  def list(options \\ []) do
    Resource.list(%Recurly.Account{}, @endpoint, options)
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

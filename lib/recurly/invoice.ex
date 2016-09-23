defmodule Recurly.Invoice do
  @moduledoc """
  Module for handling invoices in Recurly.
  See the [developer docs on invoices](https://dev.recurly.com/docs/list-invoices)
  for more details
  """
  use Recurly.Resource
  alias Recurly.{Resource,Invoice,Account,Address,Adjustment,Transaction}

  @endpoint "/invoices"

  schema :invoice do
    field :account,               Account
    field :address,               Address
    field :closed_at,             :date_time, read_only: true
    field :created_at,            :date_time, read_only: true
    field :currency,              :string
    field :customer_notes,        :string
    field :invoice_number,        :string
    field :invoice_number_prefix, :string
    field :line_items,            Adjustment, list: true
    field :net_terms,             :integer
    field :po_number,             :string
    field :state,                 :string
    field :subtotal_in_cents,     :integer
    field :tax_in_cents,          :integer
    field :tax_rate,              :float
    field :tax_region,            :string
    field :tax_type,              :string
    field :terms_and_conditions,  :string
    field :total_in_cents,        :integer
    field :transactions,          Transaction, list: true
    field :updated_at,            :date_time, read_only: true
    field :uuid,                  :string
    field :vat_number,            :string
  end

  @doc """
  Creates a stream of invoices given some options.

  ## Parameters

  - `options` Keyword list of the request options. See options in the
      [invoice list section](https://dev.recurly.com/docs/list-invoices)
      of the docs.

  ## Examples

  See `Recurly.Resource.stream/3` for more detailed examples of
  working with resource streams.

  ```
  # stream of open invoices sorted from most recently
  # updated to least recently updated
  stream = Recurly.Invoice.stream(state: :open, sort: :updated_at)
  ```
  """
  def stream(options \\ []) do
    Resource.stream(Invoice, @endpoint, options)
  end

  @doc """
  Gives the count of invoices on the server given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [invoices list section](https://dev.recurly.com/docs/list-invoices)
      of the docs.

  # Examples

  ```
  # suppose we want to count all accounts
  case Recurly.Invoice.count() do
    {:ok, count} ->
      # count => 176 (or some integer)
    {:error, err} ->
      # error occurred
  end

  # or maybe we wan to count just past_due invoices
  case Recurly.Invoice.count(state: :past_due) do
    {:ok, count} ->
      # count => 83 (or some integer)
    {:error, err} ->
      # error occurred
  end
  ```
  """
  def count(options \\ []) do
    Resource.count(@endpoint, options)
  end

  @doc """
  Gives the first invoice returned given options

  # Parameters

  - `options` Keyword list of the request options. See options in the
      [invoice list section](https://dev.recurly.com/docs/list-invoices)
      of the docs.

  # Examples

  ```
  # suppose we want the latest, open invoice
  case Recurly.Invoice.first(state: :open) do
    {:ok, invoice} ->
      # invoice => the newest open invoice
    {:error, err} ->
      # error occurred
  end

  # or maybe want the oldest, failed invoice
  case Recurly.Invoice.first(state: :failed, order: :asc) do
    {:ok, failed} ->
      # invoice => the oldest failed invoice
    {:error, err} ->
      # error occurred
  end
  ```
  """
  def first(options \\ []) do
    Resource.first(%Invoice{}, @endpoint, options)
  end

  @doc """
  Finds an invoice given an invoice number. Returns the invoice or an error.

  ## Parameters

  - `invoice_number` String invoice number

  ## Examples

  ```
  alias Recurly.NotFoundError

  case Recurly.Invoice.find("1001") do
    {:ok, invoice} ->
      # Found the invoice
    {:error, %NotFoundError{}} ->
      # 404 invoice was not found
  end
  ```
  """
  def find(invoice_number) do
    Resource.find(%Invoice{}, path(invoice_number))
  end

  @doc """
  Generates the path to an invoice given the invoice number

  ## Parameters

    - `invoice_number` String invoice number

  """
  def path(invoice_number) do
    Path.join(@endpoint, invoice_number)
  end
end

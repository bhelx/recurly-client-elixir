defmodule Recurly do
  @moduledoc """
  ## Getting Started

  *TODO* Need a good high level overview here. For now read each section on this page.
  After reading these sections, these modules may be a good place to start digging.

  - `Recurly.Resource` module responsible for creating, updating, deleting resources
  - `Recurly.Association` a struct for fetching associations to resources
  - `Recurly.Account` a good example of a resource with working examples

  ## TODOs

  - I need to figure out how to handle pagination. There is not yet a way to fetch associations
    with paginate == true.
  - Some large, nested functions need to be refactored. Some have nested ifs.
  - Need more examples and documentation
  - Typespecs
  - More tests

  ## Changesets

  At no point should you need to modify the resource structs in memory. In order to create
  or modify a resource, you must create a changeset and send that to the server.

  A changeset is represented as a nested [`Keyword list`](http://elixir-lang.org/docs/stable/elixir/Keyword.html).
  You must use the changeset to create or modify data. Consider the simplest case:

  ```
  {:ok, account} = Recurly.Account.create(account_code: "myaccountcode")
  # {:ok,
  #   %Recurly.Account{__meta__: %{actions: %{},
  #           href: "https://subdomain.recurly.com/v2/accounts/myaccountcode"},
  #           account_code: "myaccountcode", billing_info: nil, cc_emails: nil,
  #             company_name: nil, email: nil, first_name: nil, last_name: nil,
  #               state: "active", tax_exempt: nil, username: nil, vat_number: nil}}
  ```

  The `Recurly.Account.create/1` function takes only a changeset as an argument and returns the created account.
  Only the `account_code` is needed in this case.

  Consider a more complicated case with nested data:

  ```elixir
  changeset_data = [
    plan_code: "myplancode",
    currency: "USD",
     account: [
      account_code: "myotheraccountcode",
      billing_info: [
        address1: " 400 Alabama St",
        city: " San Francisco",
        state: "CA",
        zip: "94110",
        number: "4111-1111-1111-1111",
        verification_value: "123",
        first_name: "Benjamin",
        last_name: "Person",
        month: "05",
        year: 2019,
        country: "US"
      ]
     ],
     subscription_add_ons: [
       subscription_add_on: [add_on_code: "myaddon", quantity: 1]
     ]
  ]

  {:ok, subscription} = Recurly.Subscription.create(changeset_data)

  # {:ok,
  #  %Recurly.Subscription{__meta__: %{actions: %{cancel: [:put,
  #        "https://subdomain.recurly.com/v2/subscriptions/37e068b0bc916763655db141b194e626/cancel"],
  #       notes: [:put,
  #        "https://subdomain.recurly.com/v2/subscriptions/37e068b0bc916763655db141b194e626/notes"],
  #       postpone: [:put,
  #        "https://subdomain.recurly.com/v2/subscriptions/37e068b0bc916763655db141b194e626/postpone"],
  #       terminate: [:put,
  #        "https://subdomain.recurly.com/v2/subscriptions/37e068b0bc916763655db141b194e626/terminate"]},
  #     href: "https://subdomain.recurly.com/v2/subscriptions/37e068b0bc916763655db141b194e626"},
  #   account: %Recurly.Association{href: "https://subdomain.recurly.com/v2/accounts/nsnsnsns",
  #    paginate: false, resource_type: Recurly.Account}, currency: "USD",
  #   plan: %Recurly.Plan{__meta__: %{href: "https://subdomain.recurly.com/v2/plans/myplancode"},
  #    name: "A plan", plan_code: "myplancode", setup_fee_in_cents: nil,
  #    unit_amount_in_cents: nil}, plan_code: nil, quantity: 1, state: "active",
  #   subscription_add_ons: [], tax_in_cents: nil, tax_rate: nil, tax_region: nil,
  #   tax_type: nil, unit_amount_in_cents: 100,
  #   uuid: "37e068b0bc916763655db141b194e626"}}
  ```

  As you can see, the `billing_info` is nested in the `account` which is nested in the `subscription`. This is nearly a 1x1 mapping of
  the [XML request that is generated](https://dev.recurly.com/docs/create-subscription). Keep in mind that you must use
  keyword lists and never maps for changesets as maps do not support duplicate keys.

  If any of the keys in your changeset data aren't recognized, you will get an `ArgumentError`.
  This will prevent you from misspelling or sending incorrect data.

  ## Error Handling

  All network bound calls which may result in an error follow a similar API:

  ```
  case Recurly.Account.create(account_code: "myaccountcode") do
    {:ok, account} -> # *account* is the account created on the server
    {:error, error} -> # *error* is an error struct
  end
  ```

  The `error` value may be one of the following types:

  - `Recurly.NotFoundError`
  - `Recurly.ValidationError`
  - `Recurly.APIError`

  A benefit of this API is that it allows fine grained pattern matching against errors cases.
  As an example, consider that you want to detect the case in which the account code is taken:

  ```
  alias Recurly.ValidationError

  case Recurly.Account.create(account_code: "myaccountcode") do
    {:ok, account} ->
      # account code was not taken and the account was created
    {:error, %ValidationError{errors: [%{symbol: :taken}]}} ->
      # the account code was taken
    {:error, error} ->
      # a fallback case
  end
  ```

  Pattern matching function arguments is also a nice way to exploit this property:

  ```
  defmodule MyModule do
    def fetch(account_code) do
      account_code
      |> Recurly.Account.find
      |> handle_response
    end

    def handle_response({:ok, account}) do
      # account code was not used and the account was created
    end
    def handle_response({:error, %Recurly.NotFoundError{description: description}) do
      # description => Couldn't find Account with account_code = nonexistentcode
    end
    def handle_response(error) do
      # a fallback case
    end
  end

  MyModule.fetch("nonexistentcode")
  ```

  It's a good idea to always replace the value with any updated states from the server so you never have old state lying around:

  ```
  {:ok, account} = Recurly.Account.create(account_code: "myaccountcode")
  {:ok, account} = Recurly.Account.update(account, first_name: "Benjamin")
  ```

  If you need to remove an attribute you can send nils to the server:

  ```
  {:ok, account} = Recurly.Account.update(account, [
    username: nil,
    first_name: "Benjamin"
  ])
  ```

  This generates the XML:

  ```xml
  <acccount>
    <username nil="nil"/>
    <first_name>Benjamin</first_name>
  </acccount>
  ```
  """

  def api_version, do: "2.4"
  def user_agent, do: "Recurly/Elixir/0.0.1"
end

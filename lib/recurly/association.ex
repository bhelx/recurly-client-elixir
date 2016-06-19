defmodule Recurly.Association do
  @moduledoc """
  Represents an association (link) in the xml.
  An example would be the `transactions` link and
  the billing_info link on `Recurly.Account`.

  ```xml
  <account>
  <!-- ... -->
    <transactions href="https://api.recurly.com/v2/account/myaccountcode/transactions" />
    <billing_info href="https://api.recurly.com/v2/account/myaccountcode/billing_info" />
  <!-- ... -->
  </account>
  ```

  If you want to know how to fetch associations,
  see `Recurly.Resource.find/1` and (todo) `Recurly.Resource.list/1`.

  ## Struct Fields

  - `href` the href to the association
  - `resource_type` the resource type (module) responsible for the link
  - `paginate` will be true if you're expected to paginate through the resource (link `transactions`).
      It will be false if the association is a singleton (like `billing_info`)

  ## Example

  ```
  {:ok, account} = Recurly.Account.find("myaccountcode")

  account.transactions
  #=> %Recurly.Association{
  #=>   href: "https://api.recurly.com/v2/accounts/myaccountcode/transactions",
  #=>   paginate: true,
  #=>   resource_type: Recurly.Transaction}


  account.billing_info
  #=> %Recurly.Association{
  #=>   href: "https://api.recurly.com/v2/accounts/myaccountcode/billing_info",
  #=>   paginate: false,
  #=>   resource_type: Recurly.BillingInfo}
  ```
  """
  defstruct [:href, :resource_type, paginate: false]
end

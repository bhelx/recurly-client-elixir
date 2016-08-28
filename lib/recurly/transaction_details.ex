defmodule Recurly.TransactionDetails do
  @moduledoc """
  Module for representing transaction details in Recurly.
  """
  use Recurly.Resource
  alias Recurly.Account

  @type t :: %__MODULE__{
    account: Account.t,
  }

  schema :details do
    field :account, Account
  end
end

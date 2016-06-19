defmodule Recurly.TransactionDetails do
  @moduledoc """
  Module for representing transaction details in Recurly.
  """
  use Recurly.Resource

  schema :details do
    field :account, Recurly.Account
  end
end

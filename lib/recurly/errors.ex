defmodule Recurly.APIError do
  @moduledoc """
  Module represents a generic APIError with a `symbol` and `description`.
  """
  defstruct ~w(status_code symbol description)a

  defimpl Recurly.XML.Parser do
    import SweetXml

    def parse(_error, xml_doc, false) do
      parsed =
        xpath(
          xml_doc,
          ~x"//error",
          symbol: ~x"./symbol/text()"s |> transform_by(&String.to_atom/1),
          description: ~x"./description/text()"s
        )

       struct(Recurly.APIError, parsed)
    end
  end
end

defmodule Recurly.NotFoundError do
  @moduledoc """
  Module represents a not found error (404)
  ## Examples

  ```
  case Recurly.Account.find("accountdoesntexist") do
    {:ok, account} -> account
    {:error, error} -> error
  end

  # %Recurly.NotFoundError{description: "Couldn't find Account with account_code = accountdoesntexist",
  #    path: nil, status_code: 404, symbol: :not_found}
  ```
  """
  defstruct ~w(status_code path symbol description)a

  defimpl Recurly.XML.Parser do
    import SweetXml

    def parse(_error, xml_doc, false) do
      parsed =
        xpath(
          xml_doc,
          ~x"//error",
          symbol: ~x"./symbol/text()"s |> transform_by(&String.to_atom/1),
          description: ~x"./description/text()"s
        )

       struct(Recurly.NotFoundError, parsed)
    end
  end
end

defmodule Recurly.ValidationError do
  @moduledoc """
  Module represents a validation error that you may encounter on a create or update.
  See the [documentation on validation errors](https://dev.recurly.com/docs/api-validation-errors)
  for more details.

  The ValidationError is a struct that constains the `status_code` and an array of field errors called
  `errors` that map 1x1 with the xml tags.

  ## Examples

  ```
  case Recurly.Account.create(account_code: "myaccountcode") do
    {:ok, account} -> account
    {:error, error} -> error
  end

  # %Recurly.ValidationError{errors: [%{field: "account.account_code", lang: "",
  #          symbol: :taken, text: "has already been taken"}], status_code: 422}
  ```
  """
  defstruct ~w(status_code errors)a

  defimpl Recurly.XML.Parser do
    import SweetXml

    def parse(_error, xml_doc, false) do
      errors =
        xml_doc
        |> xpath(~x"//errors")
        |> xpath(~x"./error"l)
        |> Enum.map(fn xml_node ->
          %{
            symbol: xml_node |> xpath(~x"./@symbol"s) |> String.to_atom,
            field: xml_node |> xpath(~x"./@field"s),
            lang: xml_node |> xpath(~x"./@lang"s),
            text: xml_node |> xpath(~x"./text()"s)
          }
        end)

       struct(Recurly.ValidationError, %{errors: errors})
    end
  end
end

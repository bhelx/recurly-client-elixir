defmodule Recurly.API do
  @moduledoc """
  Module for making HTTP requests to Recurly servers.
  """
  require Logger

  alias HTTPoison.Response
  alias Recurly.{APILogger,XML,ValidationError,NotFoundError}

  @doc """

  ## Parameters

  - `method` Atom (:get, :post, :put, :delete)
  - `path` String can be a relative path like "/accounts/1234" or a fully qualified uri
  - `body` String HTTP body
  - `options` Keyword list of extra options
  - `headers` Map of extra headers
  """
  def make_request(method, path, body \\ "", options \\ [], headers \\ %{}) do
    headers = Map.to_list(req_headers(headers))
    endpoint = req_endpoint(path)
    options = req_options(options)

    APILogger.log_request(method, endpoint, body, headers, options)

    HTTPoison.request(method, endpoint, body, headers, options)
    |> decompress
    |> APILogger.log_response
    |> handle_response
  end

  defp decompress({:ok, response = %Response{}}) do
    gzipped = Enum.any?(response.headers, fn (kv) ->
      case kv do
        {"Content-Encoding", "gzip"} -> true
        _ -> false
      end
    end)

    if gzipped and String.length(response.body) > 0 do
      {:ok, Map.put(response, :body, :zlib.gunzip(response.body))}
    else
      {:ok, response}
    end
  end
  defp decompress(response), do: response

  defp handle_response({:ok, %Response{status_code: code, body: xml_string, headers: headers}}) when code >= 200 and code < 400 do
    headers = Enum.into(headers, %{})
    {:ok, xml_string, headers}
  end
  defp handle_response({:ok, %Response{status_code: 422, body: xml_string}}) do
    error =
      %ValidationError{}
      |> XML.Parser.parse(xml_string, false)
      |> Map.put(:status_code, 422)

    {:error, error}
  end
  defp handle_response({:ok, %Response{status_code: 404, body: xml_string}}) do
    error =
      %NotFoundError{}
      |> XML.Parser.parse(xml_string, false)
      |> Map.put(:status_code, 404)

    {:error, error}
  end
  defp handle_response({:ok, %Response{status_code: 401}}) do
    raise ArgumentError, message: "Authentication failed!"
  end
  defp handle_response(response) do
    raise ArgumentError, message: "Response not handled #{inspect response}"
  end

  @doc """
  HTTPoison request options.

  ## Parameters
    * `extras` keyword list of extra opts to merge into defaults
  """
  def req_options(extras) do
    defaults = [
      recv_timeout: 15_000,
      timeout: 15_000,
      hackney: [basic_auth: {api_key, ""}]
    ]

    Keyword.merge(defaults, extras)
  end

  @doc """
  Create the uri for given path.
  Can take a fully qualified url.

  ## Parameters
    * `path` string relative path
  """
  def req_endpoint(path) do
    case URI.parse(path) do
      %{scheme: "https"} -> path
      %{scheme: "http"} -> path
       _ -> Path.join("https://#{api_subdomain}.recurly.com/v2", path)
    end
  end

  @doc """
  HTTP request headers.

  ## Parameters
    * `extras` a Map of extra opts to merge into defaults
  """
  def req_headers(extras) do
    %{}
    |> Map.put("User-Agent",       Recurly.user_agent)
    |> Map.put("X-Api-Version",    Recurly.api_version)
    |> Map.put("Content-Type",     "application/xml; charset=utf-8")
    |> Map.put("Accept",           "application/xml")
    |> Map.put("Accept-Encoding",  "gzip,deflate")
    |> Map.merge(extras)
  end

  defp api_key do
    Application.get_env(:recurly, :private_key) || System.get_env "RECURLY_PRIVATE_KEY"
  end

  defp api_subdomain do
    Application.get_env(:recurly, :subdomain) || System.get_env "RECURLY_SUBDOMAIN"
  end
end

defmodule Recurly.APILogger do
  @moduledoc """
  Module for logging HTTP requests and responses.

  ## TODO
  - Need to implement filtering keys and PII
  """
  require Logger
  alias HTTPoison.Response

  @doc """
  Logs the request.
  """
  def log_request(method, endpoint, body, headers, options) do
    Logger.debug """
      method: #{method},
      endpoint: #{endpoint},
      body: #{body},
      headers: #{inspect headers},
      options: #{inspect options}
    """
  end

  @doc """
  Logs the response.
  """
  def log_response({:ok, response = %Response{}}) do
    Logger.debug """
      status_code: #{response.status_code}
      body: #{response.body}
      headers: #{inspect response.headers}
    """
    {:ok, response}
  end
  def log_response(response), do: response
end

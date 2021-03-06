defmodule Recurly.Page do
  @moduledoc """
  This module is responsible for working with pagination
  data. TODO needs more docs.
  """

  alias Recurly.{Resource,Page}

  @link_regex ~r/<([^>]+)>; rel\=\"next\.*"/

  defstruct [
    :resource_type,
    :resources,
    :next,
    options: [],
    total: 0
  ]

  @doc """
  Creates a new starting page
  """
  def new(resource_type, endpoint, options \\ []) do
    %Page{
      resource_type: resource_type,
      next: endpoint,
      options: options
    }
  end

  @doc """
  Create a new page from a list response.
  """
  def from_response(resource, resources, headers = %{}) do
    resource_type = resource.__struct__
    {records, _} = Integer.parse(headers["X-Records"])
    next = parse_next_link(headers["Link"])
    from_header_link(resource_type, resources, records, next)
  end

  defp from_header_link(resource_type, resources, records, nil) do
    # when there is no next link, we are at the end of the stream
    %Page{
      resource_type: resource_type,
      resources: resources,
      total: records
    }
  end
  defp from_header_link(resource_type, resources, records, next_link) do
    # take the options out of the url and make them into a list
    parsed_uri = URI.parse(next_link)
    options = URI.query_decoder(parsed_uri.query) |> Enum.to_list
    parsed_uri = Map.put(parsed_uri, :query, nil)
    next_uri = URI.to_string(parsed_uri)

    %Page{
      resource_type: resource_type,
      resources: resources,
      next: next_uri,
      total: records,
      options: options
    }
  end

  @doc """
  Turns a page into a `Stream`

  TODO needs refactoring and documentation
  """
  def to_stream(page = %Page{}) do
    Stream.resource(
      fn -> page end,
      fn page ->
        resources = page.resources
        case resources do
          [resource | rest] ->
            {[resource], Map.put(page, :resources, rest)}
          _ ->
            if (resources == nil || resources == []) && page.next do
              case Page.get_next(page) do
                {:ok, next_page} ->
                  case next_page.resources do
                    [resource | rest] ->
                      # we are returning the first resource now
                      # so we need to pop it off
                      {[resource], Map.put(next_page, :resources, rest)}
                    _ ->
                      {:halt, page}
                  end
                _err ->
                  {:halt, nil} # TODO how to handle errors?
              end
            else
              {:halt, page}
            end
        end
      end,
      fn page -> page end
    )
  end

  @doc """
  Fetches the next page
  """
  def get_next(page = %Page{}) do
    resource = struct(page.resource_type)
    Resource.list(resource, page.next, page.options)
  end

  defp parse_next_link(link_header) do
    link_header = link_header || ""
    case Regex.run(@link_regex, link_header) do
      [_header, uri] ->
        uri
      _ ->
        nil
    end
  end
end

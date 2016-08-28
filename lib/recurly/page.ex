defmodule Recurly.Page do
  @moduledoc """
  This module is responsible for working with pagination
  data. TODO needs more docs.
  """
  alias Recurly.{Resource,Page}

  @link_regex ~r/<([^>]+)>; rel\=\"next\.*"/

  @type t :: %__MODULE__{
    next:           String.t,
    resource_type:  atom,
    resources:      list,
    options:        Keyword.t,
    total:          integer,
  }

  defstruct [
    :next,
    :resource_type,
    :resources,
    options: [],
    total: 0,
  ]

  @doc """
  Creates a new starting page
  """
  @spec new(atom, String.t, keyword) :: Page.t
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
  @spec from_response(atom, list, map) :: Page.t
  def from_response(resource, resources, headers = %{}) do
    resource_type = resource.__struct__
    next = parse_next_link(headers["Link"])
    {records, _} = Integer.parse(headers["X-Records"])
    %Page{
      resource_type: resource_type,
      resources: resources,
      next: next,
      total: records
    }
  end

  @doc """
  Turns a page into a `Stream`

  TODO needs refactoring and documentation
  """
  @spec to_stream(Page.t) :: Enumerable.t
  def to_stream(page = %Page{}) do
    Stream.resource(
      fn -> page end,
      fn page ->
        resources = page.resources
        case resources do
          [resource | rest] ->
            {[resource], Map.put(page, :resources, rest)}
          _ ->
            if resources == nil || resources == [] && page.next do
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
  @spec get_next(Page.t) :: {:ok, Page.t} | {:error, any}
  def get_next(page = %Page{}) do
    resource = struct(page.resource_type)
    Resource.list(resource, page.next, [])
  end

  @spec parse_next_link(String.t) :: String.t
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

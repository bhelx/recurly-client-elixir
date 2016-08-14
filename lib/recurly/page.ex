defmodule Recurly.Page do
  @moduledoc """
  This module is responsible for working with pagination
  data. TODO needs more docs.
  """

  @link_regex ~r/<([^>]+)>; rel\=\"next\.*"/

  defstruct [
    :resource_type,
    :resources,
    :next,
    options: [],
    total: 0,
    count: 0,
    stream_idx: 0,
    stale: true
  ]

  @doc """
  Creates a new starting page
  """
  def new(resource_type, endpoint, options \\ []) do
    %Recurly.Page{
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
    next = parse_next_link(headers["Link"])
    {records, _} = Integer.parse(headers["X-Records"])
    %Recurly.Page{
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
  def to_stream(page = %Recurly.Page{}) do
    Stream.resource(
      fn -> page end,
      fn page ->
        if page.stale do # time for the next page
          case Recurly.Page.get_next(page) do
            {:ok, next_page} ->
              total = next_page.total
              count = page.count + length(next_page.resources)

              if count >= total do
                {:halt, next_page}
              else
                next_page =
                  next_page
                  |> Map.put(:count, count)
                  |> Map.put(:stale, false) # fresh fetched resources

                resource = List.first(next_page.resources)

                {[resource], next_page}
              end
            _err ->
              {:halt, nil} # TODO how to handle errors?
          end
        else # return the next resource
          resource = page.resources |> Enum.at(page.stream_idx)

          # bump the counter and determine whether we
          # need to fetch a new page next cycle
          page =
            page
            |> Map.update!(:stream_idx, &(&1 + 1))
            |> Map.put(:stale, page.stream_idx >= page.count - 1)

          {[resource], page}
        end
      end,
      fn page -> page end
    )
  end

  @doc """
  Fetches the next page
  """
  def get_next(page = %Recurly.Page{}) do
    resource = struct(page.resource_type)
    Recurly.Resource.list(resource, page.next, [])
  end

  defp parse_next_link(link_header) do
    case Regex.run(@link_regex, link_header) do
      [_header, uri] ->
        uri
      _ ->
        nil
    end
  end
end

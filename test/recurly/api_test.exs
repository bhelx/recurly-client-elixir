defmodule Recurly.APITest do
  use ExUnit.Case, async: true
  alias Recurly.API

  setup do
    {:ok, bypass: Bypass.open()}
  end

  test "requests should include all default headers", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      headers = conn.req_headers |> Enum.into(%{})

      # check that the proper headers are being set for gzip and xml
      assert Map.get(headers, "accept-encoding") == "gzip,deflate"
      assert Map.get(headers, "accept") == "application/xml"
      assert Map.get(headers, "content-type") == "application/xml; charset=utf-8"

      # check that our authorization host and key have been set
      assert Map.get(headers, "authorization") == "Basic MTVmMzI3NTZjOWM5MGI4M2YyMjMxZTYzOGRlOThiZjE6"

      # check that user agent is set with recurly's style
      assert Map.get(headers, "user-agent") == Recurly.user_agent()

      # check that the api version is set
      assert Map.get(headers, "x-api-version") == Recurly.api_version()

      Plug.Conn.resp(conn, 200, "")
    end)

    {:ok, _xml_string, _headers} = API.make_request(:get, endpoint(bypass, "/"))
  end

  test "request methods and bodies should be correct", %{bypass: bypass} do
    # TODO check that datetimes are formatted as iso8601 in query param
    params = [sort: :created_at, order: :desc]
    path = endpoint(bypass, "/accounts")
    method = "GET"
    body = ""
    extra_headers = %{"extra-header" => "extra header"}

    Bypass.expect(bypass, fn conn ->
      headers = conn.req_headers |> Enum.into(%{})

      # check that all the passed in parameters made it across
      assert conn.method == method
      assert conn.request_path == "/accounts"
      assert conn.query_string == "sort=created_at&order=desc"
      assert Map.get(headers, "extra-header") == "extra header"

      Plug.Conn.resp(conn, 200, "<accounts></accounts>")
    end)

    {:ok, body, resp_headers} = API.make_request(method, path, body, [params: params], extra_headers)

    # check that the xml body is what we expect
    assert body == "<accounts></accounts>"

    # check that the we are in fact getting the http headers back from the server
    assert Map.get(resp_headers, "cache-control") == "max-age=0, private, must-revalidate"
  end

  test "we get NotFound error on 404", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      err_doc = """
        <error>
          <symbol>not_found</symbol>
          <description>The account with account_code 'doesnotexist' not be located.</description>
        </error>
      """

      Plug.Conn.resp(conn, 404, err_doc)
    end)

    {:error, error = %Recurly.NotFoundError{}} = API.make_request(:get, endpoint(bypass, "/accounts/doesnotexist"))

    assert error.symbol == :not_found
  end

  test "we get a Validation error on 422", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      err_doc = """
        <errors>
          <error field="resource.number_field" symbol="not_a_number" lang="en-US">is not a number</error>
          <error field="resource.date_field" symbol="in_past">must be in the future</error>
        </errors>
      """

      Plug.Conn.resp(conn, 422, err_doc)
    end)

    fake_doc = """
      <resource>
        <number_field>Hello</number_field>
        <date_field>2001-09-30T17:18:19Z</number_field>
      </resource>
    """

    {:error, %Recurly.ValidationError{errors: [e1,e2]}} = API.make_request(:put, endpoint(bypass, "/resources/"), fake_doc)

    assert e1.symbol == :not_a_number
    assert e2.symbol == :in_past
  end

  test "we crash with an ArgumentError when not authenticated", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 401, "Request not authenticated!")
    end)

    assert_raise ArgumentError, fn ->
      {:ok, _body, _headers} = API.make_request(:get, endpoint(bypass, "/resources/1234"))
    end
  end

  test "we crash with an ArgumentError when the http status is not recognized", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 415, "Unsupported Media Type!")
    end)

    assert_raise ArgumentError, fn ->
      {:ok, _body, _headers} = API.make_request(:get, endpoint(bypass, "/resources/1234"))
    end
  end

  test "req_endpoint works with absolute and relative paths" do
    assert API.req_endpoint("https://mysubdomain.recurly.com/v2/path") == "https://mysubdomain.recurly.com/v2/path"
    assert API.req_endpoint("http://mysubdomain.recurly.com/v2/path") == "http://mysubdomain.recurly.com/v2/path"
    assert API.req_endpoint("/path") == "https://mysubdomain.recurly.com/v2/path"
  end

  test "we decompress the body if the server says it's gzip encoded", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      headers = Enum.concat(conn.resp_headers, [{"Content-Encoding", "gzip"}])
      conn = Map.put(conn, :resp_headers, headers)
      Plug.Conn.resp(conn, 200, :zlib.gzip("Some Compressed Content!"))
    end)

    {:ok, body, _headers} = API.make_request(:get, endpoint(bypass, "/content"))

    assert body == "Some Compressed Content!"
  end

  defp endpoint(bypass, path) do
    "http://localhost:#{bypass.port}#{path}"
  end
end

defmodule Recurly.ResourceTest do
  use ExUnit.Case, async: true
  alias Recurly.{Resource,XML}

  setup do
    mock_resource = %{
      a_string: "String",
      an_integer: 1234,
      a_float: 3.14,
      __meta__: %{
        href: "https://api.recurly.com/my_resource/1234",
        actions: %{
          cancel: [:cancel, "https://api.recurly.com/my_resource/1234/cancel"]
        }
      }
    }

    {:ok, resource: mock_resource, bypass: Bypass.open()}
  end

  test "location should return href location", %{resource: resource} do
    assert Resource.location(resource) == "https://api.recurly.com/my_resource/1234"
  end

  test "actions should return map of actions", %{resource: resource} do
    assert Resource.actions(resource) == %{cancel: [:cancel, "https://api.recurly.com/my_resource/1234/cancel"]}
  end

  test "action should return the action given a key", %{resource: resource} do
    assert Resource.action(resource, :cancel) == [:cancel, "https://api.recurly.com/my_resource/1234/cancel"]
  end

  test "Resource.count returns a count from the X-Records header", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      # Make sure our params make it through
      assert conn.request_path == "/accounts"
      assert conn.query_string == "sort=created_at&order=desc"

      headers = Enum.concat(conn.resp_headers, [{"X-Records", "100"}])
      conn = Map.put(conn, :resp_headers, headers)

      Plug.Conn.resp(conn, 200, "")
    end)

    {:ok, count} = Resource.count(endpoint(bypass, "/accounts"), sort: :created_at, order: :desc)

    # check that we parsed the count from the header and it's 100
    assert count == 100
  end

  test "Resource.list returns a single Page of resources", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      # Make sure our params make it through
      assert conn.request_path == "/my_resources"
      assert conn.query_string == "sort=created_at&order=desc&per_page=2"

      resp = """
        <my_resources>
          <my_resource href="https://api.recurly.com/my_resource/1234">
            <a_string>String</a_string>
            <an_integer type="integer">123</an_integer>
            <a_float type="float">3.14</a_float>
          </my_resource>
          <my_resource href="https://api.recurly.com/my_resource/5678">
            <a_string>String</a_string>
            <an_integer type="integer">123</an_integer>
            <a_float type="float">3.14</a_float>
          </my_resource>
        </my_resources>
      """

      # total number of records
      headers = Enum.concat(conn.resp_headers, [{"X-Records", "10"}])
      conn = Map.put(conn, :resp_headers, headers)

      Plug.Conn.resp(conn, 200, resp)
    end)

    {:ok, page} = Resource.list(%MyResource{}, endpoint(bypass, "/my_resources"), sort: :created_at, order: :desc, per_page: 2)

    assert length(page.resources) == 2
    assert page.total == 10
    assert page.resource_type == MyResource

    # ensure we parsed the resources into MyResources by checking the first one
    resource = %MyResource{} = page.resources |> List.first
    assert resource.a_string == "String"
    assert resource.an_integer == 123
    assert resource.a_float == 3.14
  end

  test "Resource.stream returns a stream of resources", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      # Make sure our params make it through
      assert conn.request_path == "/my_resources"
      assert conn.query_string == "sort=created_at&order=desc&per_page=2"

      resp = """
        <my_resources>
          <my_resource href="https://api.recurly.com/my_resource/1234">
            <a_string>String</a_string>
            <an_integer type="integer">123</an_integer>
            <a_float type="float">3.14</a_float>
          </my_resource>
          <my_resource href="https://api.recurly.com/my_resource/5678">
            <a_string>String</a_string>
            <an_integer type="integer">123</an_integer>
            <a_float type="float">3.14</a_float>
          </my_resource>
        </my_resources>
      """

      # total number of records
      headers = Enum.concat(conn.resp_headers, [{"X-Records", "10"}])
      headers = Enum.concat(headers, [{"Link", "<http://localhost:#{bypass.port}/my_resources?cursor=2045811329665823304%3A1474647715&order=desc&per_page=2&sort=created_at>; rel=\"next\""}])
      conn = Map.put(conn, :resp_headers, headers)

      Plug.Conn.resp(conn, 200, resp)
    end)

    stream = Resource.stream(MyResource, endpoint(bypass, "/my_resources"), sort: :created_at, order: :desc, per_page: 2)

    resources = Enum.take(stream, 2)

    # ensure we parsed the resources into MyResources by checking the first one
    resource = %MyResource{} = resources |> List.first
    assert resource.a_string == "String"
    assert resource.an_integer == 123
    assert resource.a_float == 3.14
  end

  test "Resource.create turns a changeset into XML and posts to the given path then returns parsed server resource", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)

      # Make sure our params make it through
      assert conn.method == "POST"
      assert conn.request_path == "/my_resources"
      assert body == "<my_resource>\n\t<a_string>My String</a_string>\n\t<an_integer>42</an_integer>\n\t<a_float>3.14</a_float>\n</my_resource>"

      resp = """
        <my_resource href="https://api.recurly.com/my_resources/1234">
          <a_string>My String</a_string>
          <an_integer type="integer">42</an_integer>
          <a_float type="float">3.14</a_float>
        </my_resource>
      """

      Plug.Conn.resp(conn, 201, resp)
    end)

    changeset = [a_string: "My String", an_integer: 42, a_float: 3.14]

    {:ok, my_resource} = Resource.create(%MyResource{}, changeset, endpoint(bypass, "/my_resources"))

    assert my_resource.a_string == "My String"
    assert my_resource.an_integer == 42
    assert my_resource.a_float == 3.14
  end

  test "Resource.updated turns a changeset into XML and puts to the resource's href then returns updated server resource", %{bypass: bypass} do
    original_resource_xml = """
      <my_resource href="#{endpoint(bypass, "/my_resources/1234")}">
        <a_string>String</a_string>
        <an_integer type="integer">42</an_integer>
        <a_float>3.14</a_float>
      </my_resource>
    """

    resource = XML.Parser.parse(%MyResource{}, original_resource_xml, false)

    Bypass.expect(bypass, fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)

      # Make sure our params make it through
      assert conn.method == "PUT"
      assert conn.request_path == "/my_resources/1234"

      # Check that the body is the expected changset xml
      assert body == "<my_resource>\n\t<a_float nil=\"nil\"/>\n\t<a_string>New String</a_string>\n\t<an_integer>43</an_integer>\n</my_resource>"

      # Return the new xml representation
      resp = """
        <my_resource href="#{endpoint(bypass, "/my_resources/1234")}">
          <a_string>New String</a_string>
          <an_integer type="integer">43</an_integer>
          <a_float nil="nil"></a_float>
        </my_resource>
      """

      Plug.Conn.resp(conn, 201, resp)
    end)

    changeset = [a_string: "New String", an_integer: 43, a_float: nil]

    {:ok, my_resource} = Resource.update(resource, changeset)

    assert my_resource.a_string == "New String"
    assert my_resource.an_integer == 43
    assert my_resource.a_float == nil
  end

  defp endpoint(bypass, path) do
    "http://localhost:#{bypass.port}#{path}"
  end
end

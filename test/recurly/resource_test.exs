defmodule Recurly.ResourceTest do
  use ExUnit.Case, async: true
  alias Recurly.Resource

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
    {:ok, resource: mock_resource}
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

  # test "from_changeset can build embedded resource from a nested changeset" do
  #   resource = %MyResource{
  #     a_string: "A String",
  #     a_float: 3.14,
  #     an_integer: 1234,
  #     an_embedded_resource: %MyEmbeddedResource{
  #       name: "An Embedded Resource",
  #       a_tripple_embedded_resource: %MyTrippleEmbeddedResource{
  #         name: "A Tripple Embedded Resource"
  #       }
  #     }
  #   }

  #   changeset = [
  #     a_string: "A String",
  #     a_float: 3.14,
  #     an_integer: 1234,
  #     an_embedded_resource: [
  #       name: "An Embedded Resource",
  #       a_tripple_embedded_resource: [
  #         name: "A Tripple Embedded Resource"
  #       ]
  #     ]
  #   ]

  #   assert resource == Resource.from_changeset(changeset, MyResource)
  # end
end

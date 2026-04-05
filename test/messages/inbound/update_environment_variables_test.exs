defmodule CeCe.Messages.Inbound.UpdateEnvironmentVariablesTest do
  use ExUnit.Case

  alias CeCe.Payload.Inbound.UpdateEnvironmentVariables

  describe "round-trip" do
    test "updateEnvironmentVariables" do
      json = ~s|{
        "type": "updateEnvironmentVariables",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "variables": {"PATH": "/usr/bin", "HOME": "/home/user"}
      }|

      decoded = JSON.decode!(json)
      struct = UpdateEnvironmentVariables.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["type"] == "updateEnvironmentVariables"
      assert encoded["variables"] == %{"PATH" => "/usr/bin", "HOME" => "/home/user"}
    end
  end
end

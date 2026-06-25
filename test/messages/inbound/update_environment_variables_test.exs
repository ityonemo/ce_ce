defmodule CeCe.Messages.Inbound.UpdateEnvironmentVariablesTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Inbound.UpdateEnvironmentVariables

  describe "round-trip" do
    test "updateEnvironmentVariables" do
      json = ~s|{
        "type": "update_environment_variables",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "variables": {"PATH": "/usr/bin", "HOME": "/home/user"}
      }|

      assert_round_trip(json, %Message{
        type: :update_environment_variables,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %UpdateEnvironmentVariables{
          type: :update_environment_variables,
          variables: %{"PATH" => "/usr/bin", "HOME" => "/home/user"}
        }
      })
    end
  end
end

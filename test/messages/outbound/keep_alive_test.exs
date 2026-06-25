defmodule CeCe.Messages.Outbound.KeepAliveTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.KeepAlive

  describe "round-trip" do
    test "keep_alive" do
      json = ~s|{
        "type": "keep_alive",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": "2024-01-01T00:00:00Z"
      }|

      assert_round_trip(json, %KeepAlive{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        timestamp: "2024-01-01T00:00:00Z"
      })
    end
  end
end

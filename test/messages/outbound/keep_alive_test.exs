defmodule CeCe.Messages.Outbound.KeepAliveTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.KeepAlive

  describe "round-trip" do
    test "keepAlive" do
      json = ~s|{
        "type": "keep_alive",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": "2024-01-01T00:00:00Z"
      }|

      assert_round_trip(json, %Message{
        type: :keep_alive,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %KeepAlive{
          timestamp: "2024-01-01T00:00:00Z"
        }
      })
    end
  end
end

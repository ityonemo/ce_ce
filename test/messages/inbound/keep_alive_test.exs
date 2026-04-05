defmodule CeCe.Messages.Inbound.KeepAliveTest do
  use ExUnit.Case

  alias CeCe.Payload.Inbound.KeepAlive

  describe "round-trip" do
    test "keepAlive" do
      json = ~s|{
        "type": "keepAlive",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": "2024-01-01T00:00:00Z"
      }|

      decoded = JSON.decode!(json)
      struct = KeepAlive.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["type"] == "keepAlive"
      assert encoded["timestamp"] == "2024-01-01T00:00:00Z"
    end
  end
end

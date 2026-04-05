defmodule CeCe.Messages.Outbound.RateLimitEventTest do
  use ExUnit.Case

  alias CeCe.Payload.Outbound.RateLimitEvent

  describe "round-trip" do
    test "rateLimitEvent" do
      json = ~s|{
        "type": "rateLimitEvent",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "rateLimit": {
          "type": "tokens",
          "retryAfter": 60,
          "message": null
        }
      }|

      decoded = JSON.decode!(json)
      struct = RateLimitEvent.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["rateLimit"]["type"] == "tokens"
      assert encoded["rateLimit"]["retryAfter"] == 60
    end
  end
end

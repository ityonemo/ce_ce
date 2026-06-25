defmodule CeCe.Messages.Outbound.RateLimitEventTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.RateLimitEvent
  alias CeCe.Content.RateLimitInfo

  describe "round-trip" do
    test "rateLimitEvent" do
      json = ~s|{
        "type": "rate_limit_event",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "rateLimit": {
          "type": "tokens",
          "retryAfter": 60,
          "message": null
        }
      }|

      assert_round_trip(json, %Message{
        type: :rate_limit_event,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %RateLimitEvent{
          rateLimit: %RateLimitInfo{
            type: "tokens",
            retryAfter: 60,
            message: nil
          }
        }
      })
    end
  end
end

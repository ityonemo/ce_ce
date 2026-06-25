defmodule CeCe.Messages.Outbound.RateLimitEventTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.RateLimitEvent
  alias CeCe.Payload.RateLimitEvent.RateLimitInfo

  describe "round-trip" do
    test "rate_limit_event with full rate_limit_info" do
      json = ~s|{
        "type": "rate_limit_event",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "rate_limit_info": {
          "status": "rejected",
          "rateLimitType": "seven_day_overage_included",
          "resetsAt": 1782423000,
          "utilization": 0.95,
          "overageInUse": true
        }
      }|

      assert_round_trip(json, %RateLimitEvent{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        rate_limit_info: %RateLimitInfo{
          status: "rejected",
          rateLimitType: "seven_day_overage_included",
          resetsAt: 1_782_423_000,
          utilization: 0.95,
          overageInUse: true,
          extra: %{}
        }
      })
    end

    test "rate_limit_event with status only (optional fields absent) plus unknown extra key" do
      # The RateLimitInfo encoder drops nil fields, so absent optional keys must
      # be omitted from the fixture for the round-trip to be exact.
      json = ~s|{
        "type": "rate_limit_event",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "rate_limit_info": {
          "status": "allowed",
          "someFutureField": "kept"
        }
      }|

      assert_round_trip(json, %RateLimitEvent{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        rate_limit_info: %RateLimitInfo{
          status: "allowed",
          extra: %{"someFutureField" => "kept"}
        }
      })
    end
  end
end

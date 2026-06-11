defmodule CeCe.Messages.Outbound.StreamEventTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.StreamEvent

  describe "round-trip" do
    test "streamEvent" do
      json = ~s|{
        "type": "streamEvent",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "eventType": "delta",
        "data": {"text": "Hello"}
      }|

      assert_round_trip(json, %Message{
        type: :streamEvent,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %StreamEvent{
          eventType: "delta",
          data: %{"text" => "Hello"}
        }
      })
    end
  end
end

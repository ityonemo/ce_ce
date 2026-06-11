defmodule CeCe.Messages.Inbound.ControlCancelRequestTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Inbound.ControlCancelRequest

  describe "round-trip" do
    test "controlCancelRequest" do
      json = ~s|{
        "type": "controlCancelRequest",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "subtype": "cancelRequest",
        "requestId": "req_123"
      }|

      assert_round_trip(json, %Message{
        type: :controlCancelRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlCancelRequest{
          subtype: :cancelRequest,
          requestId: "req_123"
        }
      })
    end
  end
end

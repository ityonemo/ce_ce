defmodule CeCe.Messages.Inbound.ControlCancelRequestTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.ControlCancelRequest

  describe "round-trip" do
    test "control_cancel_request" do
      json = ~s|{
        "type": "control_cancel_request",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "request_id": "req_123"
      }|

      assert_round_trip(json, %ControlCancelRequest{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        request_id: "req_123"
      })
    end
  end
end

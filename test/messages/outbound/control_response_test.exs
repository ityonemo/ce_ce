defmodule CeCe.Messages.Outbound.ControlResponseTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.ControlResponse

  describe "round-trip" do
    test "controlResponse" do
      json = ~s|{
        "type": "control_response",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "requestId": "req_123",
        "success": true,
        "data": {"status": "ok"},
        "error": null
      }|

      assert_round_trip(json, %Message{
        type: :control_response,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlResponse{
          requestId: "req_123",
          success: true,
          data: %{"status" => "ok"},
          error: nil
        }
      })
    end
  end
end

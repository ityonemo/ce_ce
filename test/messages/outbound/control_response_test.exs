defmodule CeCe.Messages.Outbound.ControlResponseTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.ControlResponse

  describe "round-trip" do
    test "control_response" do
      json = ~s|{
        "type": "control_response",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "response": {
          "subtype": "success",
          "request_id": "req_123",
          "response": {"status": "ok"},
          "pending_permission_requests": [
            {
              "type": "control_request",
              "request_id": "req_pending",
              "session_id": "abc-123",
              "uuid": "def-456",
              "parent_tool_use_id": null,
              "request": {
                "subtype": "get_settings"
              }
            }
          ]
        }
      }|

      assert_round_trip(json, %ControlResponse{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        response: %CeCe.Payload.ControlResponse.Success{
          request_id: "req_123",
          response: %{"status" => "ok"},
          pending_permission_requests: [
            %CeCe.Payload.ControlRequest{
              request_id: "req_pending",
              session_id: "abc-123",
              uuid: "def-456",
              parent_tool_use_id: nil,
              request: %CeCe.Payload.ControlRequest.SimpleControl{subtype: :get_settings}
            }
          ]
        }
      })
    end
  end
end

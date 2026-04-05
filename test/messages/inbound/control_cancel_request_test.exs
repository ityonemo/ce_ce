defmodule CeCe.Messages.Inbound.ControlCancelRequestTest do
  use ExUnit.Case

  alias CeCe.Payload.Inbound.ControlCancelRequest

  describe "round-trip" do
    test "controlCancelRequest" do
      json = ~s|{
        "type": "controlCancelRequest",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "requestId": "req_123"
      }|

      decoded = JSON.decode!(json)
      struct = ControlCancelRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "cancelRequest"
      assert encoded["requestId"] == "req_123"
    end
  end
end

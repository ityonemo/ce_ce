defmodule CeCe.Messages.Outbound.AuthStatusTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.AuthStatus

  describe "round-trip" do
    test "authStatus" do
      json = ~s|{
        "type": "auth_status",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "status": "authenticated",
        "message": "Login successful",
        "account": null
      }|

      assert_round_trip(json, %Message{
        type: :auth_status,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %AuthStatus{
          status: :authenticated,
          message: "Login successful",
          account: nil
        }
      })
    end
  end
end

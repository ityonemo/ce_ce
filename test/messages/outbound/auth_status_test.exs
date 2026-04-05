defmodule CeCe.Messages.Outbound.AuthStatusTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Outbound.AuthStatus

  describe "round-trip" do
    test "authStatus" do
      json = ~s|{
        "type": "authStatus",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "status": "authenticated",
        "message": "Login successful"
      }|

      assert_round_trip(json, AuthStatus, [
        "status",
        "message"
      ])
    end
  end
end

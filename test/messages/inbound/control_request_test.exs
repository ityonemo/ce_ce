defmodule CeCe.Messages.Inbound.ControlRequestTest do
  use ExUnit.Case

  alias CeCe.Payload.Inbound.ControlRequest

  describe "round-trip" do
    test "controlRequest/initialize" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "initialize",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "cwd": "/home/user",
        "systemMessage": "Be concise",
        "model": "claude-opus-4-5",
        "permissionMode": "default"
      }|

      decoded = JSON.decode!(json)
      struct = ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "initialize"
      assert encoded["cwd"] == "/home/user"
      assert encoded["systemMessage"] == "Be concise"
      assert encoded["model"] == "claude-opus-4-5"
      assert encoded["permissionMode"] == "default"
    end

    test "controlRequest/interrupt" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "interrupt",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "reason": "User cancelled"
      }|

      decoded = JSON.decode!(json)
      struct = ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "interrupt"
      assert encoded["reason"] == "User cancelled"
    end

    test "controlRequest/canUseTool" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "canUseTool",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolUseId": "toolu_123",
        "allowed": true,
        "reason": null
      }|

      decoded = JSON.decode!(json)
      struct = ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "canUseTool"
      assert encoded["toolUseId"] == "toolu_123"
      assert encoded["allowed"] == true
    end

    test "controlRequest/setModel" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "setModel",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "model": "claude-sonnet-4"
      }|

      decoded = JSON.decode!(json)
      struct = ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "setModel"
      assert encoded["model"] == "claude-sonnet-4"
    end

    test "controlRequest/mcpStatus" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "mcpStatus",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null
      }|

      decoded = JSON.decode!(json)
      struct = ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "mcpStatus"
    end
  end
end

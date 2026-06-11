defmodule CeCe.Messages.Inbound.ControlRequestTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Inbound.ControlInitialize
  alias CeCe.Payload.Inbound.ControlInterrupt
  alias CeCe.Payload.Inbound.ControlCanUseTool
  alias CeCe.Payload.Inbound.ControlSetModel
  alias CeCe.Payload.Inbound.ControlMcpStatus

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

      assert_round_trip(json, %Message{
        type: :controlRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlInitialize{
          subtype: :initialize,
          cwd: "/home/user",
          systemMessage: "Be concise",
          model: "claude-opus-4-5",
          permissionMode: "default"
        }
      })
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

      assert_round_trip(json, %Message{
        type: :controlRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlInterrupt{
          subtype: :interrupt,
          reason: "User cancelled"
        }
      })
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

      assert_round_trip(json, %Message{
        type: :controlRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlCanUseTool{
          subtype: :canUseTool,
          toolUseId: "toolu_123",
          allowed: true,
          reason: nil
        }
      })
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

      assert_round_trip(json, %Message{
        type: :controlRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlSetModel{
          subtype: :setModel,
          model: "claude-sonnet-4"
        }
      })
    end

    test "controlRequest/mcpStatus" do
      json = ~s|{
        "type": "controlRequest",
        "subtype": "mcpStatus",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null
      }|

      assert_round_trip(json, %Message{
        type: :controlRequest,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ControlMcpStatus{
          subtype: :mcpStatus
        }
      })
    end
  end
end

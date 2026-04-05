defmodule CeCe.RoundTripTest do
  use ExUnit.Case

  @moduledoc """
  Round-trip tests for JSON decode/encode of message payloads.

  Each test takes a JSON string, decodes it, parses it into a struct,
  encodes it back to JSON, and verifies the output matches expected fields.
  """

  describe "outbound payload round-trips" do
    test "system/init" do
      json = ~s|{
        "type": "system",
        "subtype": "init",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "cwd": "/home/user",
        "model": "claude-opus-4-5",
        "tools": ["Bash", "Read"],
        "agents": [{"name": "Explore", "description": "Explorer agent"}],
        "slashCommands": ["compact"],
        "mcpServers": [{"name": "playwright", "status": "connected"}],
        "permissionMode": "default",
        "apiKeySource": "env",
        "claudeCodeVersion": "1.0.0",
        "outputStyle": "default",
        "skills": [],
        "plugins": []
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.System, [
        "cwd",
        "model",
        "tools",
        "permissionMode",
        "apiKeySource",
        "claudeCodeVersion",
        "outputStyle",
        "skills"
      ])
    end

    test "system/status" do
      json = ~s|{
        "type": "system",
        "subtype": "status",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "status": "running",
        "message": "Processing request",
        "details": {}
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.System, [
        "status",
        "message",
        "details"
      ])
    end

    test "assistant with text content" do
      json = ~s|{
        "type": "assistant",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "message": {
          "model": "claude-opus-4-5",
          "id": "msg_123",
          "content": [
            {"type": "text", "text": "Hello!"}
          ],
          "stopReason": "end_turn",
          "usage": {
            "inputTokens": 100,
            "outputTokens": 50
          }
        }
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Outbound.Assistant.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      # Assistant extracts from "message" and renames "id" to "messageId"
      assert encoded["model"] == "claude-opus-4-5"
      assert encoded["messageId"] == "msg_123"
      assert encoded["stopReason"] == "end_turn"
      # Note: Text content doesn't include "type" field in struct
      assert [%{"text" => "Hello!"}] = encoded["content"]
      assert encoded["usage"]["inputTokens"] == 100
      assert encoded["usage"]["outputTokens"] == 50
    end

    test "assistant with toolUse content" do
      json = ~s|{
        "type": "assistant",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "message": {
          "model": "claude-opus-4-5",
          "id": "msg_123",
          "content": [
            {
              "type": "toolUse",
              "id": "toolu_123",
              "name": "Bash",
              "input": {"command": "ls -la"}
            }
          ],
          "stopReason": null,
          "usage": null
        }
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Outbound.Assistant.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      # Note: ToolUse content doesn't include "type" field in struct
      assert [tool_use] = encoded["content"]
      assert tool_use["id"] == "toolu_123"
      assert tool_use["name"] == "Bash"
      assert tool_use["input"] == %{"command" => "ls -la"}
    end

    test "result" do
      json = ~s|{
        "type": "result",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "result": "success",
        "subtype": "success",
        "costUsd": 0.05,
        "durationMs": 1500,
        "durationApiMs": 1200,
        "isError": false,
        "numTurns": 3,
        "usage": {
          "inputTokens": 500,
          "outputTokens": 200
        },
        "modelUsage": [
          {"model": "claude-opus-4-5", "usage": {"inputTokens": 500, "outputTokens": 200}}
        ],
        "structuredOutput": null
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.Result, [
        "result",
        "subtype",
        "costUsd",
        "durationMs",
        "durationApiMs",
        "isError",
        "numTurns",
        "structuredOutput"
      ])
    end

    test "toolProgress" do
      json = ~s|{
        "type": "toolProgress",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolUseId": "toolu_123",
        "toolName": "Bash",
        "progress": 0.5,
        "message": "Running command...",
        "content": null
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.ToolProgress, [
        "toolUseId",
        "toolName",
        "progress",
        "message",
        "content"
      ])
    end

    test "toolUseSummary" do
      json = ~s|{
        "type": "toolUseSummary",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolUseId": "toolu_123",
        "toolName": "Bash",
        "input": {"command": "ls"},
        "output": "file1.txt",
        "isError": false,
        "durationMs": 100
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.ToolUseSummary, [
        "toolUseId",
        "toolName",
        "input",
        "output",
        "isError",
        "durationMs"
      ])
    end

    test "authStatus" do
      json = ~s|{
        "type": "authStatus",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "status": "authenticated",
        "message": "Login successful"
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.AuthStatus, [
        "status",
        "message"
      ])
    end

    test "rateLimitEvent" do
      json = ~s|{
        "type": "rateLimitEvent",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "rateLimit": {
          "type": "tokens",
          "retryAfter": 60,
          "message": null
        }
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Outbound.RateLimitEvent.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      # RateLimitInfo always includes message field (even if nil)
      assert encoded["rateLimit"]["type"] == "tokens"
      assert encoded["rateLimit"]["retryAfter"] == 60
    end

    test "promptSuggestion" do
      json = ~s|{
        "type": "promptSuggestion",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "suggestions": ["Try asking about the codebase structure"]
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.PromptSuggestion, [
        "suggestions"
      ])
    end

    test "streamEvent" do
      json = ~s|{
        "type": "streamEvent",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "eventType": "delta",
        "data": {"text": "Hello"}
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.StreamEvent, [
        "eventType",
        "data"
      ])
    end

    test "controlResponse" do
      json = ~s|{
        "type": "controlResponse",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "requestId": "req_123",
        "success": true,
        "data": {"status": "ok"},
        "error": null
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.ControlResponse, [
        "requestId",
        "success",
        "data",
        "error"
      ])
    end

    test "keepAlive (outbound)" do
      json = ~s|{
        "type": "keepAlive",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": "2024-01-01T00:00:00Z"
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.KeepAlive, [
        "timestamp"
      ])
    end

    test "streamlinedText" do
      json = ~s|{
        "type": "streamlinedText",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "text": "Hello, world!"
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.StreamlinedText, [
        "text"
      ])
    end

    test "streamlinedToolUseSummary" do
      json = ~s|{
        "type": "streamlinedToolUseSummary",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolName": "Bash",
        "toolInput": {"command": "ls"},
        "toolOutput": "file1.txt",
        "toolError": null
      }|

      assert_round_trip(json, CeCe.Payload.Outbound.StreamlinedToolUseSummary, [
        "toolName",
        "toolInput",
        "toolOutput",
        "toolError"
      ])
    end
  end

  describe "inbound payload round-trips" do
    test "user with toolResult" do
      json = ~s|{
        "type": "user",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "message": {
          "role": "user",
          "content": [
            {
              "toolUseId": "toolu_123",
              "type": "toolResult",
              "content": "file1.txt"
            }
          ]
        },
        "toolUseResult": {
          "stdout": "file1.txt",
          "stderr": "",
          "interrupted": false,
          "isImage": false
        },
        "isReplay": false,
        "priority": null,
        "timestamp": null
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Inbound.User.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      # User extracts content from message
      assert encoded["type"] == "user"
      assert encoded["toolUseResult"]["stdout"] == "file1.txt"
      assert encoded["toolUseResult"]["interrupted"] == false
      assert encoded["isReplay"] == false
    end

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
      struct = CeCe.Payload.Inbound.ControlRequest.parse(decoded)
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
      struct = CeCe.Payload.Inbound.ControlRequest.parse(decoded)
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
      struct = CeCe.Payload.Inbound.ControlRequest.parse(decoded)
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
      struct = CeCe.Payload.Inbound.ControlRequest.parse(decoded)
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
      struct = CeCe.Payload.Inbound.ControlRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["subtype"] == "mcpStatus"
    end

    test "controlCancelRequest" do
      json = ~s|{
        "type": "controlCancelRequest",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "requestId": "req_123"
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Inbound.ControlCancelRequest.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      # Has default subtype: :cancelRequest
      assert encoded["subtype"] == "cancelRequest"
      assert encoded["requestId"] == "req_123"
    end

    test "keepAlive (inbound)" do
      json = ~s|{
        "type": "keepAlive",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": "2024-01-01T00:00:00Z"
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Inbound.KeepAlive.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["type"] == "keepAlive"
      assert encoded["timestamp"] == "2024-01-01T00:00:00Z"
    end

    test "updateEnvironmentVariables" do
      json = ~s|{
        "type": "updateEnvironmentVariables",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "variables": {"PATH": "/usr/bin", "HOME": "/home/user"}
      }|

      decoded = JSON.decode!(json)
      struct = CeCe.Payload.Inbound.UpdateEnvironmentVariables.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["type"] == "updateEnvironmentVariables"
      assert encoded["variables"] == %{"PATH" => "/usr/bin", "HOME" => "/home/user"}
    end
  end

  # Helper to assert that specified fields survive the round-trip
  defp assert_round_trip(json_string, module, expected_fields) do
    decoded = JSON.decode!(json_string)
    struct = module.parse(decoded)
    encoded = JSON.encode!(struct) |> JSON.decode!()

    for field <- expected_fields do
      assert Map.has_key?(encoded, field),
             "Expected field #{inspect(field)} in encoded output, got: #{inspect(Map.keys(encoded))}"

      expected_value = Map.get(decoded, field)
      actual_value = Map.get(encoded, field)

      assert actual_value == expected_value,
             "Field #{inspect(field)} mismatch:\n  expected: #{inspect(expected_value)}\n  actual: #{inspect(actual_value)}"
    end
  end
end

defmodule CeCe.Messages.Outbound.AssistantTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Assistant
  alias CeCe.Payload.Assistant.Message
  alias CeCe.Payload.Common.TextContent
  alias CeCe.Payload.Assistant.ToolUseContent

  describe "round-trip" do
    test "assistant with text content" do
      json = ~s|{
        "type": "assistant",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": null,
        "message": {
          "role": "assistant",
          "model": "claude-opus-4-5",
          "id": "msg_123",
          "content": [
            {"type": "text", "text": "Hello!"}
          ],
          "stop_reason": "end_turn",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 100,
            "output_tokens": 50,
            "cache_creation_input_tokens": null,
            "cache_read_input_tokens": null
          }
        }
      }|

      assert_round_trip(json, %Assistant{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        timestamp: nil,
        message: %Message{
          id: "msg_123",
          model: "claude-opus-4-5",
          content: [%TextContent{text: "Hello!"}],
          stop_reason: "end_turn",
          stop_sequence: nil,
          usage: %{
            "input_tokens" => 100,
            "output_tokens" => 50,
            "cache_creation_input_tokens" => nil,
            "cache_read_input_tokens" => nil
          }
        }
      })
    end

    test "assistant with tool_use content" do
      json = ~s|{
        "type": "assistant",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": null,
        "message": {
          "role": "assistant",
          "model": "claude-opus-4-5",
          "id": "msg_123",
          "content": [
            {
              "type": "tool_use",
              "id": "toolu_123",
              "name": "Bash",
              "input": {"command": "ls -la"}
            }
          ],
          "stop_reason": null,
          "stop_sequence": null,
          "usage": null
        }
      }|

      assert_round_trip(json, %Assistant{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        timestamp: nil,
        message: %Message{
          id: "msg_123",
          model: "claude-opus-4-5",
          content: [
            %ToolUseContent{id: "toolu_123", name: "Bash", input: %{"command" => "ls -la"}}
          ],
          stop_reason: nil,
          stop_sequence: nil,
          usage: nil
        }
      })
    end
  end
end

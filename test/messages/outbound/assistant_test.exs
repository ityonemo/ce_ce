defmodule CeCe.Messages.Outbound.AssistantTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.Assistant
  alias CeCe.Content.Text
  alias CeCe.Content.ToolUse
  alias CeCe.Content.Usage

  describe "round-trip" do
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
            "outputTokens": 50,
            "cacheCreationInputTokens": null,
            "cacheReadInputTokens": null
          }
        }
      }|

      assert_round_trip(json, %Message{
        type: :assistant,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %Assistant{
          model: "claude-opus-4-5",
          messageId: "msg_123",
          content: [%Text{type: :text, text: "Hello!"}],
          stopReason: "end_turn",
          usage: %Usage{
            inputTokens: 100,
            outputTokens: 50,
            cacheCreationInputTokens: nil,
            cacheReadInputTokens: nil
          }
        }
      })
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

      assert_round_trip(json, %Message{
        type: :assistant,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %Assistant{
          model: "claude-opus-4-5",
          messageId: "msg_123",
          content: [
            %ToolUse{
              type: :toolUse,
              id: "toolu_123",
              name: "Bash",
              input: %{"command" => "ls -la"}
            }
          ],
          stopReason: nil,
          usage: nil
        }
      })
    end
  end
end

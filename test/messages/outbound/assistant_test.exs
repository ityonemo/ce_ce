defmodule CeCe.Messages.Outbound.AssistantTest do
  use ExUnit.Case

  alias CeCe.Payload.Outbound.Assistant

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
            "outputTokens": 50
          }
        }
      }|

      decoded = JSON.decode!(json)
      struct = Assistant.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["model"] == "claude-opus-4-5"
      assert encoded["messageId"] == "msg_123"
      assert encoded["stopReason"] == "end_turn"
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
      struct = Assistant.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert [tool_use] = encoded["content"]
      assert tool_use["id"] == "toolu_123"
      assert tool_use["name"] == "Bash"
      assert tool_use["input"] == %{"command" => "ls -la"}
    end
  end
end

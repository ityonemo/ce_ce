defmodule CeCe.Messages.Outbound.ToolProgressTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.ToolProgress

  describe "round-trip" do
    test "toolProgress" do
      json = ~s|{
        "type": "tool_progress",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolUseId": "toolu_123",
        "toolName": "Bash",
        "progress": 0.5,
        "message": "Running command...",
        "content": null
      }|

      assert_round_trip(json, %Message{
        type: :tool_progress,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ToolProgress{
          toolUseId: "toolu_123",
          toolName: "Bash",
          progress: 0.5,
          message: "Running command...",
          content: nil
        }
      })
    end
  end
end

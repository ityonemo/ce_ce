defmodule CeCe.Messages.Outbound.ToolUseSummaryTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.ToolUseSummary

  describe "round-trip" do
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
        "error": null,
        "isError": false,
        "durationMs": 100
      }|

      assert_round_trip(json, %Message{
        type: :toolUseSummary,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %ToolUseSummary{
          toolUseId: "toolu_123",
          toolName: "Bash",
          input: %{"command" => "ls"},
          output: "file1.txt",
          error: nil,
          isError: false,
          durationMs: 100
        }
      })
    end
  end
end

defmodule CeCe.Messages.Outbound.ToolUseSummaryTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

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
        "isError": false,
        "durationMs": 100
      }|

      assert_round_trip(json, ToolUseSummary, [
        "toolUseId",
        "toolName",
        "input",
        "output",
        "isError",
        "durationMs"
      ])
    end
  end
end

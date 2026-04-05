defmodule CeCe.Messages.Outbound.StreamlinedToolUseSummaryTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Outbound.StreamlinedToolUseSummary

  describe "round-trip" do
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

      assert_round_trip(json, StreamlinedToolUseSummary, [
        "toolName",
        "toolInput",
        "toolOutput",
        "toolError"
      ])
    end
  end
end

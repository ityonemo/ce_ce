defmodule CeCe.Messages.Outbound.StreamlinedToolUseSummaryTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.StreamlinedToolUseSummary

  describe "round-trip" do
    test "streamlinedToolUseSummary" do
      json = ~s|{
        "type": "streamlined_tool_use_summary",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "toolName": "Bash",
        "toolInput": {"command": "ls"},
        "toolOutput": "file1.txt",
        "toolError": null
      }|

      assert_round_trip(json, %Message{
        type: :streamlined_tool_use_summary,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %StreamlinedToolUseSummary{
          toolName: "Bash",
          toolInput: %{"command" => "ls"},
          toolOutput: "file1.txt",
          toolError: nil
        }
      })
    end
  end
end

defmodule CeCe.Messages.Outbound.PromptSuggestionTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Outbound.PromptSuggestion

  describe "round-trip" do
    test "promptSuggestion" do
      json = ~s|{
        "type": "promptSuggestion",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "suggestions": ["Try asking about the codebase structure"]
      }|

      assert_round_trip(json, PromptSuggestion, ["suggestions"])
    end
  end
end

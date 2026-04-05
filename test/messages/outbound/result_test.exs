defmodule CeCe.Messages.Outbound.ResultTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Outbound.Result

  describe "round-trip" do
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

      assert_round_trip(json, Result, [
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
  end
end

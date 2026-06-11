defmodule CeCe.Messages.Outbound.ResultTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.Result
  alias CeCe.Content.Usage
  alias CeCe.Content.ModelUsage

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
        "sessionId": null,
        "totalCostUsd": null,
        "permissionDenials": [],
        "usage": {
          "inputTokens": 500,
          "outputTokens": 200,
          "cacheCreationInputTokens": null,
          "cacheReadInputTokens": null
        },
        "modelUsage": [
          {"model": "claude-opus-4-5", "usage": {"inputTokens": 500, "outputTokens": 200, "cacheCreationInputTokens": null, "cacheReadInputTokens": null}}
        ],
        "stopReason": null,
        "structuredOutput": null
      }|

      assert_round_trip(json, %Message{
        type: :result,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %Result{
          subtype: :success,
          costUsd: 0.05,
          durationMs: 1500,
          durationApiMs: 1200,
          isError: false,
          numTurns: 3,
          sessionId: nil,
          totalCostUsd: nil,
          permissionDenials: [],
          usage: %Usage{
            inputTokens: 500,
            outputTokens: 200,
            cacheCreationInputTokens: nil,
            cacheReadInputTokens: nil
          },
          modelUsage: [
            %ModelUsage{
              model: "claude-opus-4-5",
              usage: %Usage{
                inputTokens: 500,
                outputTokens: 200,
                cacheCreationInputTokens: nil,
                cacheReadInputTokens: nil
              }
            }
          ],
          stopReason: nil,
          result: "success",
          structuredOutput: nil
        }
      })
    end
  end
end

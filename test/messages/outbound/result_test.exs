defmodule CeCe.Messages.Outbound.ResultTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Result

  describe "round-trip" do
    test "result" do
      json = ~s|{
        "type": "result",
        "session_id": "abc-123",
        "uuid": "def-456",
        "result": "success",
        "subtype": "success",
        "errors": null,
        "duration_ms": 1500,
        "duration_api_ms": 1200,
        "is_error": false,
        "num_turns": 3,
        "total_cost_usd": null,
        "usage": {
          "input_tokens": 500,
          "output_tokens": 200,
          "cache_creation_input_tokens": null,
          "cache_read_input_tokens": null
        }
      }|

      assert_round_trip(json, %Result{
        session_id: "abc-123",
        uuid: "def-456",
        result: "success",
        subtype: "success",
        errors: nil,
        duration_ms: 1500,
        duration_api_ms: 1200,
        is_error: false,
        num_turns: 3,
        total_cost_usd: nil,
        usage: %{
          "input_tokens" => 500,
          "output_tokens" => 200,
          "cache_creation_input_tokens" => nil,
          "cache_read_input_tokens" => nil
        }
      })
    end
  end
end

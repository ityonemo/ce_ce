defmodule CeCe.Messages.Outbound.UnknownTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import CeCe.Test.RoundTrip

  alias CeCe.Payload
  alias CeCe.Payload.Unknown

  describe "unknown message types" do
    test "an unmodeled type routes to Unknown instead of crashing, and warns" do
      json = ~s|{"type":"some_future_type","session_id":"s","uuid":"u","extraKey":42}|
      decoded = JSON.decode!(json)

      log =
        capture_log(fn ->
          assert %Unknown{type: "some_future_type", session_id: "s", uuid: "u"} =
                   parsed = Payload.parse(decoded)

          assert parsed.extra == %{"extraKey" => 42}
        end)

      assert log =~ "unknown message type"
      assert log =~ "some_future_type"
    end

    test "Unknown round-trips, preserving all unmodeled keys" do
      json = ~s|{
        "type": "some_future_type",
        "session_id": "s",
        "uuid": "u",
        "alpha": 1,
        "beta": ["x", "y"]
      }|

      assert_round_trip(json, %Unknown{
        type: "some_future_type",
        session_id: "s",
        uuid: "u",
        extra: %{"alpha" => 1, "beta" => ["x", "y"]}
      })
    end
  end
end

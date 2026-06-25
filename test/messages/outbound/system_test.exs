defmodule CeCe.Messages.Outbound.SystemTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.System

  describe "round-trip" do
    test "system/init" do
      json = ~s|{
        "type": "system",
        "subtype": "init",
        "session_id": "abc-123",
        "uuid": "def-456",
        "error": null,
        "key": null,
        "cwd": "/home/user",
        "model": "claude-opus-4-5",
        "tools": ["Bash", "Read"]
      }|

      assert_round_trip(json, %System{
        subtype: "init",
        session_id: "abc-123",
        uuid: "def-456",
        error: nil,
        key: nil,
        data: %{
          "cwd" => "/home/user",
          "model" => "claude-opus-4-5",
          "tools" => ["Bash", "Read"]
        }
      })
    end

    test "system/status" do
      json = ~s|{
        "type": "system",
        "subtype": "status",
        "session_id": "abc-123",
        "uuid": "def-456",
        "error": null,
        "key": null,
        "status": "running",
        "message": "Processing request",
        "details": {}
      }|

      assert_round_trip(json, %System{
        subtype: "status",
        session_id: "abc-123",
        uuid: "def-456",
        error: nil,
        key: nil,
        data: %{
          "status" => "running",
          "message" => "Processing request",
          "details" => %{}
        }
      })
    end
  end
end

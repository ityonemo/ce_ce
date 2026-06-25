defmodule CeCe.Messages.Outbound.TranscriptMirrorTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.TranscriptMirror

  describe "round-trip" do
    test "transcript_mirror" do
      json = ~s|{
        "type": "transcript_mirror",
        "session_id": null,
        "uuid": null,
        "parent_tool_use_id": null,
        "filePath": "/tmp/session.jsonl",
        "entries": [
          {
            "type": "user",
            "uuid": "entry-1",
            "sessionId": "session-1",
            "parentUuid": null,
            "message": {"role": "user", "content": "hello"},
            "timestamp": "2026-06-25T12:00:00Z"
          }
        ]
      }|

      assert_round_trip(json, %TranscriptMirror{
        session_id: nil,
        uuid: nil,
        parent_tool_use_id: nil,
        filePath: "/tmp/session.jsonl",
        entries: [
          %{
            "type" => "user",
            "uuid" => "entry-1",
            "sessionId" => "session-1",
            "parentUuid" => nil,
            "message" => %{"role" => "user", "content" => "hello"},
            "timestamp" => "2026-06-25T12:00:00Z"
          }
        ]
      })
    end
  end
end

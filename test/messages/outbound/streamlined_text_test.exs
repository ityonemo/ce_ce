defmodule CeCe.Messages.Outbound.StreamlinedTextTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.StreamlinedText

  describe "round-trip" do
    test "streamlinedText" do
      json = ~s|{
        "type": "streamlinedText",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "text": "Hello, world!"
      }|

      assert_round_trip(json, %Message{
        type: :streamlinedText,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %StreamlinedText{
          text: "Hello, world!"
        }
      })
    end
  end
end

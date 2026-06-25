defmodule CeCe.Messages.Inbound.UserTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.User
  alias CeCe.Payload.User.Message
  alias CeCe.Payload.User.ToolResultContent

  describe "round-trip" do
    test "user with tool_result" do
      json = ~s|{
        "type": "user",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": null,
        "message": {
          "role": "user",
          "content": [
            {
              "tool_use_id": "toolu_123",
              "type": "tool_result",
              "content": "file1.txt"
            }
          ]
        }
      }|

      assert_round_trip(json, %User{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        timestamp: nil,
        message: %Message{
          content: [
            %ToolResultContent{tool_use_id: "toolu_123", content: "file1.txt"}
          ]
        }
      })
    end
  end
end

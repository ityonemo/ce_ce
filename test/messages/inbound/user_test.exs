defmodule CeCe.Messages.Inbound.UserTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Inbound.User

  describe "round-trip" do
    test "user with toolResult" do
      json = ~s|{
        "type": "user",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "message": {
          "role": "user",
          "content": [
            {
              "toolUseId": "toolu_123",
              "type": "toolResult",
              "content": "file1.txt"
            }
          ]
        },
        "toolUseResult": {
          "stdout": "file1.txt",
          "stderr": "",
          "interrupted": false,
          "isImage": false
        },
        "isReplay": false,
        "priority": null,
        "timestamp": null
      }|

      assert_round_trip(json, %Message{
        type: :user,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %User{
          type: :user,
          content: [
            %{
              "toolUseId" => "toolu_123",
              "type" => "toolResult",
              "content" => "file1.txt"
            }
          ],
          toolUseResult: %{
            stdout: "file1.txt",
            stderr: "",
            interrupted: false,
            isImage: false
          },
          isReplay: false,
          priority: nil,
          timestamp: nil
        }
      })
    end
  end
end

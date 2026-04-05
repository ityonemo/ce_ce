defmodule CeCe.Messages.Inbound.UserTest do
  use ExUnit.Case

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

      decoded = JSON.decode!(json)
      struct = User.parse(decoded)
      encoded = JSON.encode!(struct) |> JSON.decode!()

      assert encoded["type"] == "user"
      assert encoded["toolUseResult"]["stdout"] == "file1.txt"
      assert encoded["toolUseResult"]["interrupted"] == false
      assert encoded["isReplay"] == false
    end
  end
end

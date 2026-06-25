defmodule CeCeTest do
  use ExUnit.Case

  describe "CeCe.Payload.parse/1" do
    test "parses system/init message" do
      json = %{
        "type" => "system",
        "subtype" => "init",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "cwd" => "/home/user",
        "model" => "claude-opus-4-5",
        "tools" => ["Bash", "Read"]
      }

      message = CeCe.Payload.parse(json)

      assert %CeCe.Payload.System{} = message
      assert message.type == :system
      assert message.subtype == "init"
      assert message.session_id == "abc-123"
      assert message.uuid == "def-456"
      assert message.data["cwd"] == "/home/user"
      assert message.data["model"] == "claude-opus-4-5"
      assert message.data["tools"] == ["Bash", "Read"]
    end

    test "parses assistant message with text content" do
      json = %{
        "type" => "assistant",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "role" => "assistant",
          "model" => "claude-opus-4-5",
          "id" => "msg_123",
          "content" => [
            %{"type" => "text", "text" => "Hello!"}
          ],
          "stop_reason" => "end_turn",
          "usage" => %{
            "input_tokens" => 100,
            "output_tokens" => 50
          }
        }
      }

      message = CeCe.Payload.parse(json)

      assert %CeCe.Payload.Assistant{} = message
      assert message.type == :assistant
      assert %CeCe.Payload.Assistant.Message{} = message.message
      assert message.message.id == "msg_123"
      assert [%CeCe.Payload.Common.TextContent{text: "Hello!"}] = message.message.content
      assert message.message.stop_reason == "end_turn"
    end

    test "parses assistant message with tool_use content" do
      json = %{
        "type" => "assistant",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "role" => "assistant",
          "model" => "claude-opus-4-5",
          "id" => "msg_123",
          "content" => [
            %{
              "type" => "tool_use",
              "id" => "toolu_123",
              "name" => "Bash",
              "input" => %{"command" => "ls -la"}
            }
          ],
          "stop_reason" => nil,
          "usage" => nil
        }
      }

      message = CeCe.Payload.parse(json)

      assert %CeCe.Payload.Assistant{} = message

      assert [
               %CeCe.Payload.Assistant.ToolUseContent{
                 id: "toolu_123",
                 name: "Bash",
                 input: %{"command" => "ls -la"}
               }
             ] =
               message.message.content
    end

    test "parses user/tool_result message" do
      json = %{
        "type" => "user",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "role" => "user",
          "content" => [
            %{
              "tool_use_id" => "toolu_123",
              "type" => "tool_result",
              "content" => "file1.txt\nfile2.txt"
            }
          ]
        }
      }

      message = CeCe.Payload.parse(json)

      assert %CeCe.Payload.User{} = message
      assert %CeCe.Payload.User.Message{} = message.message

      assert [
               %CeCe.Payload.User.ToolResultContent{
                 tool_use_id: "toolu_123",
                 content: "file1.txt\nfile2.txt"
               }
             ] =
               message.message.content
    end
  end
end

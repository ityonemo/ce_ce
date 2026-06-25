defmodule CeCeTest do
  use ExUnit.Case

  describe "CeCe.Message.parse/1" do
    test "parses system/init message" do
      json = %{
        "type" => "system",
        "subtype" => "init",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "cwd" => "/home/user",
        "model" => "claude-opus-4-5",
        "tools" => ["Bash", "Read"],
        "agents" => ["Explore"],
        "slash_commands" => ["compact"],
        "mcp_servers" => [%{"name" => "playwright", "status" => "connected"}],
        "permissionMode" => "default",
        "apiKeySource" => "env",
        "claude_code_version" => "1.0.0",
        "output_style" => "default",
        "skills" => [],
        "plugins" => []
      }

      message = CeCe.Message.parse(json)

      assert message.type == :system
      assert message.session_id == "abc-123"
      assert message.uuid == "def-456"
      assert %CeCe.Payload.Outbound.SystemInit{} = message.payload
      assert message.payload.cwd == "/home/user"
      assert message.payload.model == "claude-opus-4-5"
      assert message.payload.tools == ["Bash", "Read"]
    end

    test "parses assistant message with text content" do
      json = %{
        "type" => "assistant",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "model" => "claude-opus-4-5",
          "id" => "msg_123",
          "content" => [
            %{"type" => "text", "text" => "Hello!"}
          ],
          "stopReason" => "end_turn",
          "usage" => %{
            "inputTokens" => 100,
            "outputTokens" => 50
          }
        }
      }

      message = CeCe.Message.parse(json)

      assert message.type == :assistant
      assert message.payload.messageId == "msg_123"
      assert [%CeCe.Content.Text{text: "Hello!"}] = message.payload.content
      assert message.payload.stopReason == "end_turn"
    end

    test "parses assistant message with toolUse content" do
      json = %{
        "type" => "assistant",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "model" => "claude-opus-4-5",
          "id" => "msg_123",
          "content" => [
            %{
              "type" => "toolUse",
              "id" => "toolu_123",
              "name" => "Bash",
              "input" => %{"command" => "ls -la"}
            }
          ],
          "stopReason" => nil,
          "usage" => nil
        }
      }

      message = CeCe.Message.parse(json)

      assert message.type == :assistant
      assert [tool_use] = message.payload.content
      assert %CeCe.Content.ToolUse{} = tool_use
      assert tool_use.id == "toolu_123"
      assert tool_use.name == "Bash"
      assert tool_use.input == %{"command" => "ls -la"}
    end

    test "parses user/toolResult message" do
      json = %{
        "type" => "user",
        "session_id" => "abc-123",
        "uuid" => "def-456",
        "parent_tool_use_id" => nil,
        "message" => %{
          "role" => "user",
          "content" => [
            %{
              "toolUseId" => "toolu_123",
              "type" => "toolResult",
              "content" => "file1.txt\nfile2.txt"
            }
          ]
        },
        "toolUseResult" => %{
          "stdout" => "file1.txt\nfile2.txt",
          "stderr" => "",
          "interrupted" => false,
          "isImage" => false
        }
      }

      message = CeCe.Message.parse(json)

      assert message.type == :user
      assert message.payload.toolUseResult.stdout == "file1.txt\nfile2.txt"
      assert message.payload.toolUseResult.stderr == ""
      assert message.payload.toolUseResult.interrupted == false
      assert message.payload.toolUseResult.isImage == false
    end
  end
end

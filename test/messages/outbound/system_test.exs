defmodule CeCe.Messages.Outbound.SystemTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Message
  alias CeCe.Payload.Outbound.SystemInit
  alias CeCe.Payload.Outbound.SystemStatus
  alias CeCe.Content.AgentInfo
  alias CeCe.Content.McpServerStatus
  alias CeCe.Content.SlashCommand

  describe "round-trip" do
    test "system/init" do
      json = ~s|{
        "type": "system",
        "subtype": "init",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "cwd": "/home/user",
        "model": "claude-opus-4-5",
        "tools": ["Bash", "Read"],
        "agents": [{"name": "Explore", "type": null, "description": "Explorer agent"}],
        "slashCommands": [{"name": "compact", "description": null, "args": []}],
        "mcpServers": [{"name": "playwright", "status": "connected", "error": null}],
        "permissionMode": "default",
        "apiKeySource": "env",
        "claudeCodeVersion": "1.0.0",
        "outputStyle": "default",
        "skills": [],
        "plugins": []
      }|

      assert_round_trip(json, %Message{
        type: :system,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %SystemInit{
          subtype: :init,
          cwd: "/home/user",
          model: "claude-opus-4-5",
          tools: ["Bash", "Read"],
          agents: [%AgentInfo{name: "Explore", type: nil, description: "Explorer agent"}],
          slashCommands: [%SlashCommand{name: "compact", description: nil, args: []}],
          mcpServers: [%McpServerStatus{name: "playwright", status: "connected", error: nil}],
          permissionMode: "default",
          apiKeySource: "env",
          claudeCodeVersion: "1.0.0",
          outputStyle: "default",
          skills: [],
          plugins: []
        }
      })
    end

    test "system/status" do
      json = ~s|{
        "type": "system",
        "subtype": "status",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "status": "running",
        "message": "Processing request",
        "details": {}
      }|

      assert_round_trip(json, %Message{
        type: :system,
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        payload: %SystemStatus{
          subtype: :status,
          status: "running",
          message: "Processing request",
          details: %{}
        }
      })
    end
  end
end

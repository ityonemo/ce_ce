defmodule CeCe.Messages.Outbound.SystemTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.Outbound.System

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
        "agents": [{"name": "Explore", "description": "Explorer agent"}],
        "slashCommands": ["compact"],
        "mcpServers": [{"name": "playwright", "status": "connected"}],
        "permissionMode": "default",
        "apiKeySource": "env",
        "claudeCodeVersion": "1.0.0",
        "outputStyle": "default",
        "skills": [],
        "plugins": []
      }|

      assert_round_trip(json, System, [
        "cwd",
        "model",
        "tools",
        "permissionMode",
        "apiKeySource",
        "claudeCodeVersion",
        "outputStyle",
        "skills"
      ])
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

      assert_round_trip(json, System, [
        "status",
        "message",
        "details"
      ])
    end
  end
end

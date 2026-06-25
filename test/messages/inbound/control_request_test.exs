defmodule CeCe.Messages.Inbound.ControlRequestTest do
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload.ControlRequest

  describe "round-trip" do
    test "control_request/initialize" do
      json = ~s|{
        "type": "control_request",
        "request_id": "req_initialize",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "request": {
          "subtype": "initialize",
          "hooks": null,
          "sdkMcpServers": ["mcp-one"],
          "jsonSchema": {"type": "object"},
          "systemPrompt": ["Be concise"],
          "appendSystemPrompt": null,
          "planModeInstructions": null,
          "appendSubagentSystemPrompt": null,
          "toolAliases": null,
          "excludeDynamicSections": null,
          "agents": null,
          "title": "Session title",
          "skills": ["Read"],
          "webSearchIsolationExemptMcpServers": null,
          "promptSuggestions": null,
          "agentProgressSummaries": null,
          "forwardSubagentText": false
        }
      }|

      assert_round_trip(json, %ControlRequest{
        request_id: "req_initialize",
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        request: %CeCe.Payload.ControlRequest.Initialize{
          hooks: nil,
          sdkMcpServers: ["mcp-one"],
          jsonSchema: %{"type" => "object"},
          systemPrompt: ["Be concise"],
          appendSystemPrompt: nil,
          planModeInstructions: nil,
          appendSubagentSystemPrompt: nil,
          toolAliases: nil,
          excludeDynamicSections: nil,
          agents: nil,
          title: "Session title",
          skills: ["Read"],
          webSearchIsolationExemptMcpServers: nil,
          promptSuggestions: nil,
          agentProgressSummaries: nil,
          forwardSubagentText: false
        }
      })
    end

    test "control_request/can_use_tool" do
      json = ~s|{
        "type": "control_request",
        "request_id": "req_can_use_tool",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "request": {
          "subtype": "can_use_tool",
          "tool_name": "Bash",
          "input": {"command": "ls"},
          "permission_suggestions": null,
          "blocked_path": null,
          "decision_reason": null,
          "title": null,
          "display_name": null,
          "description": null,
          "tool_use_id": "toolu_123",
          "agent_id": null
        }
      }|

      assert_round_trip(json, %ControlRequest{
        request_id: "req_can_use_tool",
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        request: %CeCe.Payload.ControlRequest.CanUseTool{
          tool_name: "Bash",
          input: %{"command" => "ls"},
          permission_suggestions: nil,
          blocked_path: nil,
          decision_reason: nil,
          title: nil,
          display_name: nil,
          description: nil,
          tool_use_id: "toolu_123",
          agent_id: nil
        }
      })
    end
  end
end

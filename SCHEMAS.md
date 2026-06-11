# SCHEMAS.md

## Scope

This file is a comprehensive record of the allowed message shapes for the NDJSON protocol used by:

- `--input-format stream-json`
- `--output-format stream-json`

The canonical schema definitions live in:

- [entrypoints/sdk/coreSchemas.ts](/home/ityonemo/code/cc/src/entrypoints/sdk/coreSchemas.ts)
- [entrypoints/sdk/controlSchemas.ts](/home/ityonemo/code/cc/src/entrypoints/sdk/controlSchemas.ts)

Implementation/runtime handling lives in:

- [main.tsx](/home/ityonemo/code/cc/src/main.tsx)
- [cli/print.ts](/home/ityonemo/code/cc/src/cli/print.ts)
- [cli/structuredIO.ts](/home/ityonemo/code/cc/src/cli/structuredIO.ts)
- [utils/streamJsonStdoutGuard.ts](/home/ityonemo/code/cc/src/utils/streamJsonStdoutGuard.ts)

The wire format is NDJSON: one JSON object per line.

## Important naming

The valid flags here are:

- `--input-format stream-json`
- `--output-format stream-json`

Not:

- `--input json`
- `--output streaming-json`

## Canonical unions

### Inbound stdin union

`StdinMessageSchema` accepts exactly:

1. `SDKUserMessage`
2. `SDKControlRequest`
3. `SDKControlResponse`
4. `SDKKeepAliveMessage`
5. `SDKUpdateEnvironmentVariablesMessage`

### Outbound stdout union

`StdoutMessageSchema` accepts exactly:

1. every `SDKMessage`
2. `SDKStreamlinedTextMessage`
3. `SDKStreamlinedToolUseSummaryMessage`
4. `SDKPostTurnSummaryMessage`
5. `SDKControlResponse`
6. `SDKControlRequest`
7. `SDKControlCancelRequest`
8. `SDKKeepAliveMessage`

### Main SDK message union

`SDKMessageSchema` includes exactly:

1. `SDKAssistantMessage`
2. `SDKUserMessage`
3. `SDKUserMessageReplay`
4. `SDKResultMessage`
5. `SDKSystemMessage` (`system:init`)
6. `SDKPartialAssistantMessage` (`stream_event`)
7. `SDKCompactBoundaryMessage`
8. `SDKStatusMessage`
9. `SDKAPIRetryMessage`
10. `SDKLocalCommandOutputMessage`
11. `SDKHookStartedMessage`
12. `SDKHookProgressMessage`
13. `SDKHookResponseMessage`
14. `SDKToolProgressMessage`
15. `SDKAuthStatusMessage`
16. `SDKTaskNotificationMessage`
17. `SDKTaskStartedMessage`
18. `SDKTaskProgressMessage`
19. `SDKSessionStateChangedMessage`
20. `SDKFilesPersistedEvent`
21. `SDKToolUseSummaryMessage`
22. `SDKRateLimitEvent`
23. `SDKElicitationCompleteMessage`
24. `SDKPromptSuggestionMessage`

## Inbound shapes

### 1. `user`

Accepted inbound shape:

```json
{
  "type": "user",
  "message": "API user message object",
  "parent_tool_use_id": "string|null",
  "isSynthetic": "boolean?",
  "tool_use_result": "unknown?",
  "priority": "\"now\"|\"next\"|\"later\"?",
  "timestamp": "string?",
  "uuid": "string?",
  "session_id": "string?"
}
```

Notes:

- `message` must have user role semantics; `StructuredIO` rejects non-user roles for `type: "user"`.
- `uuid` and `session_id` are optional inbound.
- `tool_use_result` is accepted structurally but is only meaningful to some hosts.

### 2. `control_request`

Wrapper shape:

```json
{
  "type": "control_request",
  "request_id": "string",
  "request": {
    "subtype": "..."
  }
}
```

Allowed `request.subtype` values and payloads:

#### `initialize`

```json
{
  "subtype": "initialize",
  "hooks": {
    "HookEvent": [
      {
        "matcher": "string?",
        "hookCallbackIds": ["string", "..."],
        "timeout": "number?"
      }
    ]
  }?,
  "sdkMcpServers": ["string", "..."]?,
  "jsonSchema": { "key": "unknown", "...": "unknown" }?,
  "systemPrompt": "string?",
  "appendSystemPrompt": "string?",
  "agents": {
    "agentName": "AgentDefinition",
    "...": "AgentDefinition"
  }?,
  "promptSuggestions": "boolean?",
  "agentProgressSummaries": "boolean?"
}
```

#### `interrupt`

```json
{
  "subtype": "interrupt"
}
```

#### `can_use_tool`

```json
{
  "subtype": "can_use_tool",
  "tool_name": "string",
  "input": { "key": "unknown", "...": "unknown" },
  "permission_suggestions": ["PermissionUpdate", "..."]?,
  "blocked_path": "string?",
  "decision_reason": "string?",
  "title": "string?",
  "display_name": "string?",
  "tool_use_id": "string",
  "agent_id": "string?",
  "description": "string?"
}
```

#### `set_permission_mode`

```json
{
  "subtype": "set_permission_mode",
  "mode": "PermissionMode",
  "ultraplan": "boolean?"
}
```

#### `set_model`

```json
{
  "subtype": "set_model",
  "model": "string?"
}
```

#### `set_max_thinking_tokens`

```json
{
  "subtype": "set_max_thinking_tokens",
  "max_thinking_tokens": "number|null"
}
```

#### `mcp_status`

```json
{
  "subtype": "mcp_status"
}
```

#### `get_context_usage`

```json
{
  "subtype": "get_context_usage"
}
```

#### `rewind_files`

```json
{
  "subtype": "rewind_files",
  "user_message_id": "string",
  "dry_run": "boolean?"
}
```

#### `cancel_async_message`

```json
{
  "subtype": "cancel_async_message",
  "message_uuid": "string"
}
```

#### `seed_read_state`

```json
{
  "subtype": "seed_read_state",
  "path": "string",
  "mtime": "number"
}
```

#### `hook_callback`

```json
{
  "subtype": "hook_callback",
  "callback_id": "string",
  "input": "HookInput",
  "tool_use_id": "string?"
}
```

#### `mcp_message`

```json
{
  "subtype": "mcp_message",
  "server_name": "string",
  "message": "unknown"
}
```

#### `mcp_set_servers`

```json
{
  "subtype": "mcp_set_servers",
  "servers": {
    "serverName": "McpServerConfigForProcessTransport",
    "...": "McpServerConfigForProcessTransport"
  }
}
```

#### `reload_plugins`

```json
{
  "subtype": "reload_plugins"
}
```

#### `mcp_reconnect`

```json
{
  "subtype": "mcp_reconnect",
  "serverName": "string"
}
```

#### `mcp_toggle`

```json
{
  "subtype": "mcp_toggle",
  "serverName": "string",
  "enabled": "boolean"
}
```

#### `stop_task`

```json
{
  "subtype": "stop_task",
  "task_id": "string"
}
```

#### `apply_flag_settings`

```json
{
  "subtype": "apply_flag_settings",
  "settings": {
    "key": "unknown",
    "...": "unknown"
  }
}
```

#### `get_settings`

```json
{
  "subtype": "get_settings"
}
```

#### `elicitation`

```json
{
  "subtype": "elicitation",
  "mcp_server_name": "string",
  "message": "string",
  "mode": "\"form\"|\"url\"?",
  "url": "string?",
  "elicitation_id": "string?",
  "requested_schema": {
    "key": "unknown",
    "...": "unknown"
  }?
}
```

### 3. `control_response`

Wrapper shape:

```json
{
  "type": "control_response",
  "response": {
    "subtype": "success|error",
    "request_id": "string",
    "response": "object?",
    "error": "string?"
  }
}
```

Success payload:

```json
{
  "subtype": "success",
  "request_id": "string",
  "response": {
    "key": "unknown",
    "...": "unknown"
  }?
}
```

Error payload:

```json
{
  "subtype": "error",
  "request_id": "string",
  "error": "string",
  "pending_permission_requests": ["SDKControlRequest", "..."]?
}
```

Known response bodies used by the protocol:

#### `initialize` success response

```json
{
  "commands": ["SlashCommand", "..."],
  "agents": ["AgentInfo", "..."],
  "output_style": "string",
  "available_output_styles": ["string", "..."],
  "models": ["ModelInfo", "..."],
  "account": "AccountInfo",
  "pid": "number?",
  "fast_mode_state": "\"off\"|\"cooldown\"|\"on\"?"
}
```

#### `mcp_status` success response

```json
{
  "mcpServers": ["McpServerStatus", "..."]
}
```

#### `get_context_usage` success response

```json
{
  "categories": [
    {
      "name": "string",
      "tokens": "number",
      "color": "string",
      "isDeferred": "boolean?"
    }
  ],
  "totalTokens": "number",
  "maxTokens": "number",
  "rawMaxTokens": "number",
  "percentage": "number",
  "gridRows": [
    [
      {
        "color": "string",
        "isFilled": "boolean",
        "categoryName": "string",
        "tokens": "number",
        "percentage": "number",
        "squareFullness": "number"
      }
    ]
  ],
  "model": "string",
  "memoryFiles": [
    {
      "path": "string",
      "type": "string",
      "tokens": "number"
    }
  ],
  "mcpTools": [
    {
      "name": "string",
      "serverName": "string",
      "tokens": "number",
      "isLoaded": "boolean?"
    }
  ],
  "deferredBuiltinTools": [
    {
      "name": "string",
      "tokens": "number",
      "isLoaded": "boolean"
    }
  ]?,
  "systemTools": [
    {
      "name": "string",
      "tokens": "number"
    }
  ]?,
  "systemPromptSections": [
    {
      "name": "string",
      "tokens": "number"
    }
  ]?,
  "agents": [
    {
      "agentType": "string",
      "source": "string",
      "tokens": "number"
    }
  ],
  "slashCommands": {
    "totalCommands": "number",
    "includedCommands": "number",
    "tokens": "number"
  }?,
  "skills": {
    "totalSkills": "number",
    "includedSkills": "number",
    "tokens": "number",
    "skillFrontmatter": [
      {
        "name": "string",
        "source": "string",
        "tokens": "number"
      }
    ]
  }?,
  "autoCompactThreshold": "number?",
  "isAutoCompactEnabled": "boolean",
  "messageBreakdown": {
    "toolCallTokens": "number",
    "toolResultTokens": "number",
    "attachmentTokens": "number",
    "assistantMessageTokens": "number",
    "userMessageTokens": "number",
    "toolCallsByType": [
      {
        "name": "string",
        "callTokens": "number",
        "resultTokens": "number"
      }
    ],
    "attachmentsByType": [
      {
        "name": "string",
        "tokens": "number"
      }
    ]
  }?,
  "apiUsage": {
    "input_tokens": "number",
    "output_tokens": "number",
    "cache_creation_input_tokens": "number",
    "cache_read_input_tokens": "number"
  }|null
}
```

#### `rewind_files` success response

```json
{
  "canRewind": "boolean",
  "error": "string?",
  "filesChanged": ["string", "..."]?,
  "insertions": "number?",
  "deletions": "number?"
}
```

#### `cancel_async_message` success response

```json
{
  "cancelled": "boolean"
}
```

#### `mcp_set_servers` success response

```json
{
  "added": ["string", "..."],
  "removed": ["string", "..."],
  "errors": {
    "serverName": "string",
    "...": "string"
  }
}
```

#### `reload_plugins` success response

```json
{
  "commands": ["SlashCommand", "..."],
  "agents": ["AgentInfo", "..."],
  "plugins": [
    {
      "name": "string",
      "path": "string",
      "source": "string?"
    }
  ],
  "mcpServers": ["McpServerStatus", "..."],
  "error_count": "number"
}
```

#### `get_settings` success response

```json
{
  "effective": {
    "key": "unknown",
    "...": "unknown"
  },
  "sources": [
    {
      "source": "\"userSettings\"|\"projectSettings\"|\"localSettings\"|\"flagSettings\"|\"policySettings\"",
      "settings": {
        "key": "unknown",
        "...": "unknown"
      }
    }
  ],
  "applied": {
    "model": "string",
    "effort": "\"low\"|\"medium\"|\"high\"|\"max\"|null"
  }?
}
```

#### `elicitation` success response

```json
{
  "action": "\"accept\"|\"decline\"|\"cancel\"",
  "content": {
    "key": "unknown",
    "...": "unknown"
  }?
}
```

### 4. `keep_alive`

```json
{
  "type": "keep_alive"
}
```

### 5. `update_environment_variables`

```json
{
  "type": "update_environment_variables",
  "variables": {
    "KEY": "VALUE",
    "...": "VALUE"
  }
}
```

## Outbound shapes

### A. Core SDK messages

#### 1. `assistant`

```json
{
  "type": "assistant",
  "message": "API assistant message object",
  "parent_tool_use_id": "string|null",
  "error": "\"rate_limit\"|\"invalid_request\"|\"server_error\"|\"unknown\"|\"max_output_tokens\"?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 2. `user`

Same shape as inbound `user`.

#### 3. `user` replay

```json
{
  "type": "user",
  "message": "API user message object",
  "parent_tool_use_id": "string|null",
  "isSynthetic": "boolean?",
  "tool_use_result": "unknown?",
  "priority": "\"now\"|\"next\"|\"later\"?",
  "timestamp": "string?",
  "uuid": "string",
  "session_id": "string",
  "isReplay": true
}
```

#### 4. `result` success

```json
{
  "type": "result",
  "subtype": "success",
  "duration_ms": "number",
  "duration_api_ms": "number",
  "is_error": "boolean",
  "num_turns": "number",
  "result": "string",
  "stop_reason": "string|null",
  "total_cost_usd": "number",
  "usage": "NonNullableUsage",
  "modelUsage": {
    "modelName": "ModelUsage",
    "...": "ModelUsage"
  },
  "permission_denials": [
    {
      "tool_name": "string",
      "tool_use_id": "string",
      "tool_input": {
        "key": "unknown",
        "...": "unknown"
      }
    }
  ],
  "structured_output": "unknown?",
  "fast_mode_state": "\"off\"|\"cooldown\"|\"on\"?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 5. `result` error

```json
{
  "type": "result",
  "subtype": "\"error_during_execution\"|\"error_max_turns\"|\"error_max_budget_usd\"|\"error_max_structured_output_retries\"",
  "duration_ms": "number",
  "duration_api_ms": "number",
  "is_error": "boolean",
  "num_turns": "number",
  "stop_reason": "string|null",
  "total_cost_usd": "number",
  "usage": "NonNullableUsage",
  "modelUsage": {
    "modelName": "ModelUsage",
    "...": "ModelUsage"
  },
  "permission_denials": ["SDKPermissionDenial", "..."],
  "errors": ["string", "..."],
  "fast_mode_state": "\"off\"|\"cooldown\"|\"on\"?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 6. `system:init`

```json
{
  "type": "system",
  "subtype": "init",
  "agents": ["string", "..."]?,
  "apiKeySource": "ApiKeySource",
  "betas": ["string", "..."]?,
  "claude_code_version": "string",
  "cwd": "string",
  "tools": ["string", "..."],
  "mcp_servers": [
    {
      "name": "string",
      "status": "string"
    }
  ],
  "model": "string",
  "permissionMode": "PermissionMode",
  "slash_commands": ["string", "..."],
  "output_style": "string",
  "skills": ["string", "..."],
  "plugins": [
    {
      "name": "string",
      "path": "string",
      "source": "string?"
    }
  ],
  "fast_mode_state": "\"off\"|\"cooldown\"|\"on\"?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 7. `stream_event`

```json
{
  "type": "stream_event",
  "event": "raw message stream event",
  "parent_tool_use_id": "string|null",
  "uuid": "string",
  "session_id": "string"
}
```

#### 8. `system:compact_boundary`

```json
{
  "type": "system",
  "subtype": "compact_boundary",
  "compact_metadata": {
    "trigger": "\"manual\"|\"auto\"",
    "pre_tokens": "number",
    "preserved_segment": {
      "head_uuid": "string",
      "anchor_uuid": "string",
      "tail_uuid": "string"
    }?
  },
  "uuid": "string",
  "session_id": "string"
}
```

#### 9. `system:status`

```json
{
  "type": "system",
  "subtype": "status",
  "status": "\"compacting\"|null",
  "permissionMode": "PermissionMode?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 10. `system:post_turn_summary`

```json
{
  "type": "system",
  "subtype": "post_turn_summary",
  "summarizes_uuid": "string",
  "status_category": "\"blocked\"|\"waiting\"|\"completed\"|\"review_ready\"|\"failed\"",
  "status_detail": "string",
  "is_noteworthy": "boolean",
  "title": "string",
  "description": "string",
  "recent_action": "string",
  "needs_action": "string",
  "artifact_urls": ["string", "..."],
  "uuid": "string",
  "session_id": "string"
}
```

#### 11. `system:api_retry`

```json
{
  "type": "system",
  "subtype": "api_retry",
  "attempt": "number",
  "max_retries": "number",
  "retry_delay_ms": "number",
  "error_status": "number|null",
  "error": "\"rate_limit\"|\"invalid_request\"|\"server_error\"|\"unknown\"|\"max_output_tokens\"",
  "uuid": "string",
  "session_id": "string"
}
```

#### 12. `system:local_command_output`

```json
{
  "type": "system",
  "subtype": "local_command_output",
  "content": "string",
  "uuid": "string",
  "session_id": "string"
}
```

#### 13. `system:hook_started`

```json
{
  "type": "system",
  "subtype": "hook_started",
  "hook_id": "string",
  "hook_name": "string",
  "hook_event": "string",
  "uuid": "string",
  "session_id": "string"
}
```

#### 14. `system:hook_progress`

```json
{
  "type": "system",
  "subtype": "hook_progress",
  "hook_id": "string",
  "hook_name": "string",
  "hook_event": "string",
  "stdout": "string",
  "stderr": "string",
  "output": "string",
  "uuid": "string",
  "session_id": "string"
}
```

#### 15. `system:hook_response`

```json
{
  "type": "system",
  "subtype": "hook_response",
  "hook_id": "string",
  "hook_name": "string",
  "hook_event": "string",
  "output": "string",
  "stdout": "string",
  "stderr": "string",
  "exit_code": "number?",
  "outcome": "\"success\"|\"error\"|\"cancelled\"",
  "uuid": "string",
  "session_id": "string"
}
```

#### 16. `tool_progress`

```json
{
  "type": "tool_progress",
  "tool_use_id": "string",
  "tool_name": "string",
  "parent_tool_use_id": "string|null",
  "elapsed_time_seconds": "number",
  "task_id": "string?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 17. `auth_status`

```json
{
  "type": "auth_status",
  "isAuthenticating": "boolean",
  "output": ["string", "..."],
  "error": "string?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 18. `system:files_persisted`

```json
{
  "type": "system",
  "subtype": "files_persisted",
  "files": [
    {
      "filename": "string",
      "file_id": "string"
    }
  ],
  "failed": [
    {
      "filename": "string",
      "error": "string"
    }
  ],
  "processed_at": "string",
  "uuid": "string",
  "session_id": "string"
}
```

#### 19. `system:task_notification`

```json
{
  "type": "system",
  "subtype": "task_notification",
  "task_id": "string",
  "tool_use_id": "string?",
  "status": "\"completed\"|\"failed\"|\"stopped\"",
  "output_file": "string",
  "summary": "string",
  "usage": {
    "total_tokens": "number",
    "tool_uses": "number",
    "duration_ms": "number"
  }?,
  "uuid": "string",
  "session_id": "string"
}
```

#### 20. `system:task_started`

```json
{
  "type": "system",
  "subtype": "task_started",
  "task_id": "string",
  "tool_use_id": "string?",
  "description": "string",
  "task_type": "string?",
  "workflow_name": "string?",
  "prompt": "string?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 21. `system:session_state_changed`

```json
{
  "type": "system",
  "subtype": "session_state_changed",
  "state": "\"idle\"|\"running\"|\"requires_action\"",
  "uuid": "string",
  "session_id": "string"
}
```

#### 22. `system:task_progress`

```json
{
  "type": "system",
  "subtype": "task_progress",
  "task_id": "string",
  "tool_use_id": "string?",
  "description": "string",
  "usage": {
    "total_tokens": "number",
    "tool_uses": "number",
    "duration_ms": "number"
  },
  "last_tool_name": "string?",
  "summary": "string?",
  "uuid": "string",
  "session_id": "string"
}
```

#### 23. `tool_use_summary`

```json
{
  "type": "tool_use_summary",
  "summary": "string",
  "preceding_tool_use_ids": ["string", "..."],
  "uuid": "string",
  "session_id": "string"
}
```

#### 24. `rate_limit_event`

```json
{
  "type": "rate_limit_event",
  "rate_limit_info": {
    "status": "\"allowed\"|\"allowed_warning\"|\"rejected\"",
    "resetsAt": "number?",
    "rateLimitType": "\"five_hour\"|\"seven_day\"|\"seven_day_opus\"|\"seven_day_sonnet\"|\"overage\"?",
    "utilization": "number?",
    "overageStatus": "\"allowed\"|\"allowed_warning\"|\"rejected\"?",
    "overageResetsAt": "number?",
    "overageDisabledReason": "\"overage_not_provisioned\"|\"org_level_disabled\"|\"org_level_disabled_until\"|\"out_of_credits\"|\"seat_tier_level_disabled\"|\"member_level_disabled\"|\"seat_tier_zero_credit_limit\"|\"group_zero_credit_limit\"|\"member_zero_credit_limit\"|\"org_service_level_disabled\"|\"org_service_zero_credit_limit\"|\"no_limits_configured\"|\"unknown\"?",
    "isUsingOverage": "boolean?",
    "surpassedThreshold": "number?"
  },
  "uuid": "string",
  "session_id": "string"
}
```

#### 25. `system:elicitation_complete`

```json
{
  "type": "system",
  "subtype": "elicitation_complete",
  "mcp_server_name": "string",
  "elicitation_id": "string",
  "uuid": "string",
  "session_id": "string"
}
```

#### 26. `prompt_suggestion`

```json
{
  "type": "prompt_suggestion",
  "suggestion": "string",
  "uuid": "string",
  "session_id": "string"
}
```

### B. Additional outbound-only protocol messages

#### 27. `control_request`

Same wrapper and subtype payloads as inbound `control_request`.

Operationally, the CLI emits these when it needs the host to do something, especially:

- `can_use_tool`
- `elicitation`

#### 28. `control_response`

Same wrapper shape as inbound `control_response`.

#### 29. `control_cancel_request`

```json
{
  "type": "control_cancel_request",
  "request_id": "string"
}
```

#### 30. `keep_alive`

```json
{
  "type": "keep_alive"
}
```

#### 31. `streamlined_text`

```json
{
  "type": "streamlined_text",
  "text": "string",
  "session_id": "string",
  "uuid": "string"
}
```

#### 32. `streamlined_tool_use_summary`

```json
{
  "type": "streamlined_tool_use_summary",
  "tool_summary": "string",
  "session_id": "string",
  "uuid": "string"
}
```

## Notes on actual runtime behavior

- `--input-format=stream-json` requires `--output-format=stream-json`.
- `--output-format=stream-json` requires `--verbose` in print mode.
- stdin is parsed line-by-line by [cli/structuredIO.ts](/home/ityonemo/code/cc/src/cli/structuredIO.ts).
- stdout is guarded by [utils/streamJsonStdoutGuard.ts](/home/ityonemo/code/cc/src/utils/streamJsonStdoutGuard.ts) so stray non-JSON writes are diverted to stderr.
- This protocol is a local transport/control layer around the same core query engine used by headless CLI mode.

## Distinct from interactive mode?

Yes locally, no in the core model loop.

`stream-json` surfaces protocol messages that interactive Ink mode does not emit over stdout, including:

- initialization/control responses
- permission control requests
- task/progress/status/hook/rate-limit events
- replay acknowledgments

But the underlying execution still routes through the same:

- [cli/print.ts](/home/ityonemo/code/cc/src/cli/print.ts)
- [QueryEngine.ts](/home/ityonemo/code/cc/src/QueryEngine.ts)
- [query.ts](/home/ityonemo/code/cc/src/query.ts)

So this is primarily a transport/protocol distinction, not a separate model-backend mode.

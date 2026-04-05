defmodule CeCe.Payload.Inbound.ControlRequest do
  @moduledoc """
  Control request dispatcher.

  Routes to the appropriate control request subtype based on the `subtype` field.

  ## Subtypes

  - `initialize` - Initialize session (`CeCe.Payload.Inbound.ControlInitialize`)
  - `interrupt` - Interrupt operation (`CeCe.Payload.Inbound.ControlInterrupt`)
  - `can_use_tool` - Tool permission response (`CeCe.Payload.Inbound.ControlCanUseTool`)
  - `set_permission_mode` - Set permission mode (`CeCe.Payload.Inbound.ControlSetPermissionMode`)
  - `set_model` - Set model (`CeCe.Payload.Inbound.ControlSetModel`)
  - `set_max_thinking_tokens` - Set max thinking tokens (`CeCe.Payload.Inbound.ControlSetMaxThinkingTokens`)
  - `mcp_status` - Get MCP status (`CeCe.Payload.Inbound.ControlMcpStatus`)
  - `get_context_usage` - Get context usage (`CeCe.Payload.Inbound.ControlGetContextUsage`)
  - `rewind_files` - Rewind files (`CeCe.Payload.Inbound.ControlRewindFiles`)
  - `cancel_async_message` - Cancel async message (`CeCe.Payload.Inbound.ControlCancelAsyncMessage`)
  - `seed_read_state` - Seed read state (`CeCe.Payload.Inbound.ControlSeedReadState`)
  - `hook_callback` - Hook callback (`CeCe.Payload.Inbound.ControlHookCallback`)
  - `mcp_message` - MCP message (`CeCe.Payload.Inbound.ControlMcpMessage`)
  - `mcp_set_servers` - Set MCP servers (`CeCe.Payload.Inbound.ControlMcpSetServers`)
  - `reload_plugins` - Reload plugins (`CeCe.Payload.Inbound.ControlReloadPlugins`)
  - `mcp_reconnect` - Reconnect MCP (`CeCe.Payload.Inbound.ControlMcpReconnect`)
  - `mcp_toggle` - Toggle MCP server (`CeCe.Payload.Inbound.ControlMcpToggle`)
  - `stop_task` - Stop task (`CeCe.Payload.Inbound.ControlStopTask`)
  - `apply_flag_settings` - Apply flag settings (`CeCe.Payload.Inbound.ControlApplyFlagSettings`)
  - `get_settings` - Get settings (`CeCe.Payload.Inbound.ControlGetSettings`)
  - `elicitation` - Elicitation response (`CeCe.Payload.Inbound.ControlElicitation`)
  """

  alias CeCe.Payload.Inbound.ControlInitialize
  alias CeCe.Payload.Inbound.ControlInterrupt
  alias CeCe.Payload.Inbound.ControlCanUseTool
  alias CeCe.Payload.Inbound.ControlSetPermissionMode
  alias CeCe.Payload.Inbound.ControlSetModel
  alias CeCe.Payload.Inbound.ControlSetMaxThinkingTokens
  alias CeCe.Payload.Inbound.ControlMcpStatus
  alias CeCe.Payload.Inbound.ControlGetContextUsage
  alias CeCe.Payload.Inbound.ControlRewindFiles
  alias CeCe.Payload.Inbound.ControlCancelAsyncMessage
  alias CeCe.Payload.Inbound.ControlSeedReadState
  alias CeCe.Payload.Inbound.ControlHookCallback
  alias CeCe.Payload.Inbound.ControlMcpMessage
  alias CeCe.Payload.Inbound.ControlMcpSetServers
  alias CeCe.Payload.Inbound.ControlReloadPlugins
  alias CeCe.Payload.Inbound.ControlMcpReconnect
  alias CeCe.Payload.Inbound.ControlMcpToggle
  alias CeCe.Payload.Inbound.ControlStopTask
  alias CeCe.Payload.Inbound.ControlApplyFlagSettings
  alias CeCe.Payload.Inbound.ControlGetSettings
  alias CeCe.Payload.Inbound.ControlElicitation

  @type t ::
          ControlInitialize.t()
          | ControlInterrupt.t()
          | ControlCanUseTool.t()
          | ControlSetPermissionMode.t()
          | ControlSetModel.t()
          | ControlSetMaxThinkingTokens.t()
          | ControlMcpStatus.t()
          | ControlGetContextUsage.t()
          | ControlRewindFiles.t()
          | ControlCancelAsyncMessage.t()
          | ControlSeedReadState.t()
          | ControlHookCallback.t()
          | ControlMcpMessage.t()
          | ControlMcpSetServers.t()
          | ControlReloadPlugins.t()
          | ControlMcpReconnect.t()
          | ControlMcpToggle.t()
          | ControlStopTask.t()
          | ControlApplyFlagSettings.t()
          | ControlGetSettings.t()
          | ControlElicitation.t()
          | map()

  @doc """
  Parse a control request, dispatching to the appropriate subtype.
  """
  def parse(%{"subtype" => "initialize"} = json), do: ControlInitialize.parse(json)
  def parse(%{"subtype" => "interrupt"} = json), do: ControlInterrupt.parse(json)
  def parse(%{"subtype" => "can_use_tool"} = json), do: ControlCanUseTool.parse(json)
  def parse(%{"subtype" => "canUseTool"} = json), do: ControlCanUseTool.parse(json)

  def parse(%{"subtype" => "set_permission_mode"} = json),
    do: ControlSetPermissionMode.parse(json)

  def parse(%{"subtype" => "setPermissionMode"} = json), do: ControlSetPermissionMode.parse(json)
  def parse(%{"subtype" => "set_model"} = json), do: ControlSetModel.parse(json)
  def parse(%{"subtype" => "setModel"} = json), do: ControlSetModel.parse(json)

  def parse(%{"subtype" => "set_max_thinking_tokens"} = json),
    do: ControlSetMaxThinkingTokens.parse(json)

  def parse(%{"subtype" => "setMaxThinkingTokens"} = json),
    do: ControlSetMaxThinkingTokens.parse(json)

  def parse(%{"subtype" => "mcp_status"} = json), do: ControlMcpStatus.parse(json)
  def parse(%{"subtype" => "mcpStatus"} = json), do: ControlMcpStatus.parse(json)
  def parse(%{"subtype" => "get_context_usage"} = json), do: ControlGetContextUsage.parse(json)
  def parse(%{"subtype" => "getContextUsage"} = json), do: ControlGetContextUsage.parse(json)
  def parse(%{"subtype" => "rewind_files"} = json), do: ControlRewindFiles.parse(json)
  def parse(%{"subtype" => "rewindFiles"} = json), do: ControlRewindFiles.parse(json)

  def parse(%{"subtype" => "cancel_async_message"} = json),
    do: ControlCancelAsyncMessage.parse(json)

  def parse(%{"subtype" => "cancelAsyncMessage"} = json),
    do: ControlCancelAsyncMessage.parse(json)

  def parse(%{"subtype" => "seed_read_state"} = json), do: ControlSeedReadState.parse(json)
  def parse(%{"subtype" => "seedReadState"} = json), do: ControlSeedReadState.parse(json)
  def parse(%{"subtype" => "hook_callback"} = json), do: ControlHookCallback.parse(json)
  def parse(%{"subtype" => "hookCallback"} = json), do: ControlHookCallback.parse(json)
  def parse(%{"subtype" => "mcp_message"} = json), do: ControlMcpMessage.parse(json)
  def parse(%{"subtype" => "mcpMessage"} = json), do: ControlMcpMessage.parse(json)
  def parse(%{"subtype" => "mcp_set_servers"} = json), do: ControlMcpSetServers.parse(json)
  def parse(%{"subtype" => "mcpSetServers"} = json), do: ControlMcpSetServers.parse(json)
  def parse(%{"subtype" => "reload_plugins"} = json), do: ControlReloadPlugins.parse(json)
  def parse(%{"subtype" => "reloadPlugins"} = json), do: ControlReloadPlugins.parse(json)
  def parse(%{"subtype" => "mcp_reconnect"} = json), do: ControlMcpReconnect.parse(json)
  def parse(%{"subtype" => "mcpReconnect"} = json), do: ControlMcpReconnect.parse(json)
  def parse(%{"subtype" => "mcp_toggle"} = json), do: ControlMcpToggle.parse(json)
  def parse(%{"subtype" => "mcpToggle"} = json), do: ControlMcpToggle.parse(json)
  def parse(%{"subtype" => "stop_task"} = json), do: ControlStopTask.parse(json)
  def parse(%{"subtype" => "stopTask"} = json), do: ControlStopTask.parse(json)

  def parse(%{"subtype" => "apply_flag_settings"} = json),
    do: ControlApplyFlagSettings.parse(json)

  def parse(%{"subtype" => "applyFlagSettings"} = json), do: ControlApplyFlagSettings.parse(json)
  def parse(%{"subtype" => "get_settings"} = json), do: ControlGetSettings.parse(json)
  def parse(%{"subtype" => "getSettings"} = json), do: ControlGetSettings.parse(json)
  def parse(%{"subtype" => "elicitation"} = json), do: ControlElicitation.parse(json)

  # Fallback for unknown subtypes
  def parse(json) when is_map(json) do
    %{raw: json, subtype: json["subtype"]}
  end
end

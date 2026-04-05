defmodule CeCe.Payload.Inbound.ControlRequest do
  @moduledoc """
  Control request dispatcher.

  Routes to the appropriate control request subtype based on the `subtype` field.
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

  @subtype_map %{
    "initialize" => ControlInitialize,
    "interrupt" => ControlInterrupt,
    "canUseTool" => ControlCanUseTool,
    "setPermissionMode" => ControlSetPermissionMode,
    "setModel" => ControlSetModel,
    "setMaxThinkingTokens" => ControlSetMaxThinkingTokens,
    "mcpStatus" => ControlMcpStatus,
    "getContextUsage" => ControlGetContextUsage,
    "rewindFiles" => ControlRewindFiles,
    "cancelAsyncMessage" => ControlCancelAsyncMessage,
    "seedReadState" => ControlSeedReadState,
    "hookCallback" => ControlHookCallback,
    "mcpMessage" => ControlMcpMessage,
    "mcpSetServers" => ControlMcpSetServers,
    "reloadPlugins" => ControlReloadPlugins,
    "mcpReconnect" => ControlMcpReconnect,
    "mcpToggle" => ControlMcpToggle,
    "stopTask" => ControlStopTask,
    "applyFlagSettings" => ControlApplyFlagSettings,
    "getSettings" => ControlGetSettings,
    "elicitation" => ControlElicitation
  }

  @doc """
  Parse a control request, dispatching to the appropriate subtype.
  """
  def parse(%{"subtype" => subtype} = json) do
    Map.fetch!(@subtype_map, subtype).parse(json)
  end
end

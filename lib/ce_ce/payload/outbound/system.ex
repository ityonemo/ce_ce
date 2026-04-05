defmodule CeCe.Payload.Outbound.System do
  @moduledoc """
  System payload dispatcher.

  Routes to the appropriate system subtype based on the `subtype` field.
  """

  alias CeCe.Payload.Outbound.SystemInit
  alias CeCe.Payload.Outbound.SystemStatus
  alias CeCe.Payload.Outbound.SystemCompactBoundary
  alias CeCe.Payload.Outbound.SystemApiRetry
  alias CeCe.Payload.Outbound.SystemLocalCommandOutput
  alias CeCe.Payload.Outbound.SystemHookStarted
  alias CeCe.Payload.Outbound.SystemHookProgress
  alias CeCe.Payload.Outbound.SystemHookResponse
  alias CeCe.Payload.Outbound.SystemFilesPersisted
  alias CeCe.Payload.Outbound.SystemTaskNotification
  alias CeCe.Payload.Outbound.SystemTaskStarted
  alias CeCe.Payload.Outbound.SystemTaskProgress
  alias CeCe.Payload.Outbound.SystemSessionStateChanged
  alias CeCe.Payload.Outbound.SystemPostTurnSummary
  alias CeCe.Payload.Outbound.SystemElicitationComplete

  @type t ::
          SystemInit.t()
          | SystemStatus.t()
          | SystemCompactBoundary.t()
          | SystemApiRetry.t()
          | SystemLocalCommandOutput.t()
          | SystemHookStarted.t()
          | SystemHookProgress.t()
          | SystemHookResponse.t()
          | SystemFilesPersisted.t()
          | SystemTaskNotification.t()
          | SystemTaskStarted.t()
          | SystemTaskProgress.t()
          | SystemSessionStateChanged.t()
          | SystemPostTurnSummary.t()
          | SystemElicitationComplete.t()

  @subtype_map %{
    "init" => SystemInit,
    "status" => SystemStatus,
    "compactBoundary" => SystemCompactBoundary,
    "apiRetry" => SystemApiRetry,
    "localCommandOutput" => SystemLocalCommandOutput,
    "hookStarted" => SystemHookStarted,
    "hookProgress" => SystemHookProgress,
    "hookResponse" => SystemHookResponse,
    "filesPersisted" => SystemFilesPersisted,
    "taskNotification" => SystemTaskNotification,
    "taskStarted" => SystemTaskStarted,
    "taskProgress" => SystemTaskProgress,
    "sessionStateChanged" => SystemSessionStateChanged,
    "postTurnSummary" => SystemPostTurnSummary,
    "elicitationComplete" => SystemElicitationComplete
  }

  @doc """
  Parse a system message, dispatching to the appropriate subtype.
  """
  def parse(%{"subtype" => subtype} = json) do
    Map.fetch!(@subtype_map, subtype).parse(json)
  end
end

defmodule CeCe.Payload.Outbound.System do
  @moduledoc """
  System payload dispatcher.

  Routes to the appropriate system subtype based on the `subtype` field.

  ## Subtypes

  - `init` - Session initialization (`CeCe.Payload.Outbound.SystemInit`)
  - `status` - Status update (`CeCe.Payload.Outbound.SystemStatus`)
  - `compact_boundary` - Compact boundary marker (`CeCe.Payload.Outbound.SystemCompactBoundary`)
  - `api_retry` - API retry notification (`CeCe.Payload.Outbound.SystemApiRetry`)
  - `local_command_output` - Local command output (`CeCe.Payload.Outbound.SystemLocalCommandOutput`)
  - `hook_started` - Hook execution started (`CeCe.Payload.Outbound.SystemHookStarted`)
  - `hook_progress` - Hook execution progress (`CeCe.Payload.Outbound.SystemHookProgress`)
  - `hook_response` - Hook execution response (`CeCe.Payload.Outbound.SystemHookResponse`)
  - `files_persisted` - Files saved to disk (`CeCe.Payload.Outbound.SystemFilesPersisted`)
  - `task_notification` - Task notification (`CeCe.Payload.Outbound.SystemTaskNotification`)
  - `task_started` - Task started (`CeCe.Payload.Outbound.SystemTaskStarted`)
  - `task_progress` - Task progress (`CeCe.Payload.Outbound.SystemTaskProgress`)
  - `session_state_changed` - Session state changed (`CeCe.Payload.Outbound.SystemSessionStateChanged`)
  - `post_turn_summary` - Post-turn summary (`CeCe.Payload.Outbound.SystemPostTurnSummary`)
  - `elicitation_complete` - Elicitation complete (`CeCe.Payload.Outbound.SystemElicitationComplete`)
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
          | map()

  @doc """
  Parse a system message, dispatching to the appropriate subtype.
  """
  def parse(%{"subtype" => "init"} = json), do: SystemInit.parse(json)
  def parse(%{"subtype" => "status"} = json), do: SystemStatus.parse(json)
  def parse(%{"subtype" => "compact_boundary"} = json), do: SystemCompactBoundary.parse(json)
  def parse(%{"subtype" => "compactBoundary"} = json), do: SystemCompactBoundary.parse(json)
  def parse(%{"subtype" => "api_retry"} = json), do: SystemApiRetry.parse(json)
  def parse(%{"subtype" => "apiRetry"} = json), do: SystemApiRetry.parse(json)

  def parse(%{"subtype" => "local_command_output"} = json),
    do: SystemLocalCommandOutput.parse(json)

  def parse(%{"subtype" => "localCommandOutput"} = json), do: SystemLocalCommandOutput.parse(json)
  def parse(%{"subtype" => "hook_started"} = json), do: SystemHookStarted.parse(json)
  def parse(%{"subtype" => "hookStarted"} = json), do: SystemHookStarted.parse(json)
  def parse(%{"subtype" => "hook_progress"} = json), do: SystemHookProgress.parse(json)
  def parse(%{"subtype" => "hookProgress"} = json), do: SystemHookProgress.parse(json)
  def parse(%{"subtype" => "hook_response"} = json), do: SystemHookResponse.parse(json)
  def parse(%{"subtype" => "hookResponse"} = json), do: SystemHookResponse.parse(json)
  def parse(%{"subtype" => "files_persisted"} = json), do: SystemFilesPersisted.parse(json)
  def parse(%{"subtype" => "filesPersisted"} = json), do: SystemFilesPersisted.parse(json)
  def parse(%{"subtype" => "task_notification"} = json), do: SystemTaskNotification.parse(json)
  def parse(%{"subtype" => "taskNotification"} = json), do: SystemTaskNotification.parse(json)
  def parse(%{"subtype" => "task_started"} = json), do: SystemTaskStarted.parse(json)
  def parse(%{"subtype" => "taskStarted"} = json), do: SystemTaskStarted.parse(json)
  def parse(%{"subtype" => "task_progress"} = json), do: SystemTaskProgress.parse(json)
  def parse(%{"subtype" => "taskProgress"} = json), do: SystemTaskProgress.parse(json)

  def parse(%{"subtype" => "session_state_changed"} = json),
    do: SystemSessionStateChanged.parse(json)

  def parse(%{"subtype" => "sessionStateChanged"} = json),
    do: SystemSessionStateChanged.parse(json)

  def parse(%{"subtype" => "post_turn_summary"} = json), do: SystemPostTurnSummary.parse(json)
  def parse(%{"subtype" => "postTurnSummary"} = json), do: SystemPostTurnSummary.parse(json)

  def parse(%{"subtype" => "elicitation_complete"} = json),
    do: SystemElicitationComplete.parse(json)

  def parse(%{"subtype" => "elicitationComplete"} = json),
    do: SystemElicitationComplete.parse(json)

  # Fallback for unknown subtypes - return raw map with parsed subtype
  def parse(json) when is_map(json) do
    %{raw: json, subtype: json["subtype"]}
  end
end

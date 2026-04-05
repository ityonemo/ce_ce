defmodule CeCe.Message do
  @moduledoc """
  Common message wrapper for all Claude Code CLI messages.

  All messages share these fields:
  - `type` - Message type atom
  - `session_id` - Session UUID
  - `uuid` - Message UUID
  - `parent_tool_use_id` - Parent tool use ID (nil if not a tool response)
  - `payload` - Type-specific payload struct

  ## Message Types

  Core message types:
  - `:system` - System messages (init, status, hooks, etc.)
  - `:assistant` - Claude's responses (text, tool use)
  - `:user` - User messages and tool results
  - `:result` - Turn completion results

  Additional message types:
  - `:stream_event` - Raw stream events
  - `:tool_progress` - Tool execution progress
  - `:auth_status` - Authentication status
  - `:tool_use_summary` - Tool use summaries
  - `:rate_limit_event` - Rate limiting events
  - `:prompt_suggestion` - Prompt suggestions
  - `:control_request` - Control requests
  - `:control_response` - Control responses
  - `:control_cancel_request` - Control cancel requests
  - `:keep_alive` - Heartbeat messages
  - `:streamlined_text` - Streamlined text output
  - `:streamlined_tool_use_summary` - Streamlined tool summaries
  - `:update_environment_variables` - Environment variable updates
  """

  # Outbound payloads (received from CLI)
  alias CeCe.Payload.Outbound.System
  alias CeCe.Payload.Outbound.Assistant
  alias CeCe.Payload.Outbound.Result
  alias CeCe.Payload.Outbound.StreamEvent
  alias CeCe.Payload.Outbound.ToolProgress
  alias CeCe.Payload.Outbound.AuthStatus
  alias CeCe.Payload.Outbound.ToolUseSummary
  alias CeCe.Payload.Outbound.RateLimitEvent
  alias CeCe.Payload.Outbound.PromptSuggestion
  alias CeCe.Payload.Outbound.ControlResponse
  alias CeCe.Payload.Outbound.KeepAlive
  alias CeCe.Payload.Outbound.StreamlinedText
  alias CeCe.Payload.Outbound.StreamlinedToolUseSummary

  # Inbound payloads (sent to CLI) - for parsing echoed messages
  alias CeCe.Payload.Inbound.User
  alias CeCe.Payload.Inbound.ControlRequest
  alias CeCe.Payload.Inbound.ControlCancelRequest
  alias CeCe.Payload.Inbound.UpdateEnvironmentVariables

  use CeCe.AccessFunctions

  @type message_type ::
          :system
          | :assistant
          | :user
          | :result
          | :stream_event
          | :tool_progress
          | :auth_status
          | :tool_use_summary
          | :rate_limit_event
          | :prompt_suggestion
          | :control_request
          | :control_response
          | :control_cancel_request
          | :keep_alive
          | :streamlined_text
          | :streamlined_tool_use_summary
          | :update_environment_variables
          | :unknown

  @type t :: %__MODULE__{
          type: message_type(),
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          payload: struct() | map()
        }

  defstruct [:type, :session_id, :uuid, :parent_tool_use_id, :payload]

  @doc """
  Parse a JSON map into a Message struct with the appropriate payload.
  """
  def parse(json) when is_map(json) do
    %__MODULE__{
      type: parse_type(json["type"]),
      session_id: json["session_id"],
      uuid: json["uuid"],
      parent_tool_use_id: json["parent_tool_use_id"],
      payload: parse_payload(json)
    }
  end

  # Core message types
  defp parse_type("system"), do: :system
  defp parse_type("assistant"), do: :assistant
  defp parse_type("user"), do: :user
  defp parse_type("result"), do: :result

  # Additional message types
  defp parse_type("stream_event"), do: :stream_event
  defp parse_type("streamEvent"), do: :stream_event
  defp parse_type("tool_progress"), do: :tool_progress
  defp parse_type("toolProgress"), do: :tool_progress
  defp parse_type("auth_status"), do: :auth_status
  defp parse_type("authStatus"), do: :auth_status
  defp parse_type("tool_use_summary"), do: :tool_use_summary
  defp parse_type("toolUseSummary"), do: :tool_use_summary
  defp parse_type("rate_limit_event"), do: :rate_limit_event
  defp parse_type("rateLimitEvent"), do: :rate_limit_event
  defp parse_type("prompt_suggestion"), do: :prompt_suggestion
  defp parse_type("promptSuggestion"), do: :prompt_suggestion
  defp parse_type("control_request"), do: :control_request
  defp parse_type("controlRequest"), do: :control_request
  defp parse_type("control_response"), do: :control_response
  defp parse_type("controlResponse"), do: :control_response
  defp parse_type("control_cancel_request"), do: :control_cancel_request
  defp parse_type("controlCancelRequest"), do: :control_cancel_request
  defp parse_type("keep_alive"), do: :keep_alive
  defp parse_type("keepAlive"), do: :keep_alive
  defp parse_type("streamlined_text"), do: :streamlined_text
  defp parse_type("streamlinedText"), do: :streamlined_text
  defp parse_type("streamlined_tool_use_summary"), do: :streamlined_tool_use_summary
  defp parse_type("streamlinedToolUseSummary"), do: :streamlined_tool_use_summary
  defp parse_type("update_environment_variables"), do: :update_environment_variables
  defp parse_type("updateEnvironmentVariables"), do: :update_environment_variables
  defp parse_type(_), do: :unknown

  # Core payload parsers
  defp parse_payload(%{"type" => "system"} = json), do: System.parse(json)
  defp parse_payload(%{"type" => "assistant"} = json), do: Assistant.parse(json)
  defp parse_payload(%{"type" => "user"} = json), do: User.parse(json)
  defp parse_payload(%{"type" => "result"} = json), do: Result.parse(json)

  # Additional payload parsers
  defp parse_payload(%{"type" => type} = json) when type in ["stream_event", "streamEvent"] do
    StreamEvent.parse(json)
  end

  defp parse_payload(%{"type" => type} = json) when type in ["tool_progress", "toolProgress"] do
    ToolProgress.parse(json)
  end

  defp parse_payload(%{"type" => type} = json) when type in ["auth_status", "authStatus"] do
    AuthStatus.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["tool_use_summary", "toolUseSummary"] do
    ToolUseSummary.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["rate_limit_event", "rateLimitEvent"] do
    RateLimitEvent.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["prompt_suggestion", "promptSuggestion"] do
    PromptSuggestion.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["control_request", "controlRequest"] do
    ControlRequest.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["control_response", "controlResponse"] do
    ControlResponse.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["control_cancel_request", "controlCancelRequest"] do
    ControlCancelRequest.parse(json)
  end

  defp parse_payload(%{"type" => type} = json) when type in ["keep_alive", "keepAlive"] do
    KeepAlive.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["streamlined_text", "streamlinedText"] do
    StreamlinedText.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["streamlined_tool_use_summary", "streamlinedToolUseSummary"] do
    StreamlinedToolUseSummary.parse(json)
  end

  defp parse_payload(%{"type" => type} = json)
       when type in ["update_environment_variables", "updateEnvironmentVariables"] do
    UpdateEnvironmentVariables.parse(json)
  end

  # Fallback for unknown types
  defp parse_payload(json), do: %{raw: json}
end

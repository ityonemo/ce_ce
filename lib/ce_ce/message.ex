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
          | :streamEvent
          | :toolProgress
          | :authStatus
          | :toolUseSummary
          | :rateLimitEvent
          | :promptSuggestion
          | :controlRequest
          | :controlResponse
          | :controlCancelRequest
          | :keepAlive
          | :streamlinedText
          | :streamlinedToolUseSummary
          | :updateEnvironmentVariables
          | :unknown

  @type t :: %__MODULE__{
          type: message_type(),
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          payload: struct() | json()
        }

  @type json :: nil | boolean | String.t() | number | [json] | %{optional(String.t()) => json}

  defstruct [:type, :session_id, :uuid, :parent_tool_use_id, :payload]

  @doc """
  Parse a JSON map into a Message struct with the appropriate payload.
  """
  def parse(json) do
    %__MODULE__{
      type: parse_type!(json),
      session_id: Map.fetch!(json, "session_id"),
      uuid: Map.fetch!(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      payload: parse_payload!(json)
    }
  end

  @types ~w[system assistant user result streamEvent toolProgress authStatus toolUseSummary
             rateLimitEvent promptSuggestion controlRequest controlResponse controlCancelRequest
             keepAlive streamlinedText streamlinedToolUseSummary updateEnvironmentVariables]a

  @type_map Map.new(@types, &{"#{&1}", &1})

  defp parse_type!(json) do
    json
    |> Map.fetch!("type")
    |> then(&Map.fetch!(@type_map, &1))
  end

  @payload_map %{
    "system" => System,
    "assistant" => Assistant,
    "user" => User,
    "result" => Result,
    "streamEvent" => StreamEvent,
    "toolProgress" => ToolProgress,
    "authStatus" => AuthStatus,
    "toolUseSummary" => ToolUseSummary,
    "rateLimitEvent" => RateLimitEvent,
    "promptSuggestion" => PromptSuggestion,
    "controlRequest" => ControlRequest,
    "controlResponse" => ControlResponse,
    "controlCancelRequest" => ControlCancelRequest,
    "keepAlive" => KeepAlive,
    "streamlinedText" => StreamlinedText,
    "streamlinedToolUseSummary" => StreamlinedToolUseSummary,
    "updateEnvironmentVariables" => UpdateEnvironmentVariables
  }

  defp parse_payload!(%{"type" => type} = json) do
    Map.fetch!(@payload_map, type).parse(json)
  end
end

defimpl JSON.Encoder, for: CeCe.Message do
  def encode(message, encoder) do
    # Encode payload to get its fields
    payload_json =
      message.payload
      |> JSON.encode!()
      |> JSON.decode!()

    # Merge with top-level message fields
    map =
      %{
        "type" => Atom.to_string(message.type),
        "session_id" => message.session_id,
        "uuid" => message.uuid,
        "parent_tool_use_id" => message.parent_tool_use_id
      }
      |> Map.merge(payload_json)

    JSON.Encoder.Map.encode(map, encoder)
  end
end

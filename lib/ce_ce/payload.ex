defmodule CeCe.Payload do
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

  - `:control_request` - Control requests
  - `:control_response` - Control responses
  - `:control_cancel_request` - Control cancel requests
  - `:keep_alive` - Heartbeat messages
  - `:transcript_mirror` - Transcript mirror batches
  """

  alias CeCe.Payload.User
  alias CeCe.Payload.Assistant
  alias CeCe.Payload.System
  alias CeCe.Payload.Result
  alias CeCe.Payload.ControlRequest
  alias CeCe.Payload.ControlResponse
  alias CeCe.Payload.ControlCancelRequest
  alias CeCe.Payload.KeepAlive
  alias CeCe.Payload.TranscriptMirror

  @type input() ::
          User.t()
          | Assistant.t()
          | System.t()
          | ControlRequest.t()
          | ControlResponse.t()

  @type output() ::
          User.t()
          | Assistant.t()
          | System.t()
          | Result.t()
          | ControlRequest.t()
          | ControlResponse.t()
          | ControlCancelRequest.t()
          | KeepAlive.t()
          | TranscriptMirror.t()

  @type t() :: input() | output()

  @type json :: nil | boolean | String.t() | number | [json] | %{optional(String.t()) => json}

  @payload_map %{
    "user" => User,
    "assistant" => Assistant,
    "system" => System,
    "result" => Result,
    "control_request" => ControlRequest,
    "control_response" => ControlResponse,
    "control_cancel_request" => ControlCancelRequest,
    "keep_alive" => KeepAlive,
    "transcript_mirror" => TranscriptMirror
  }

  @spec parse(json) :: t
  def parse(%{"type" => type} = json) do
    Map.fetch!(@payload_map, type).parse(json)
  end

  def _encode_json_merging(struct, extra_field, encoder) do
    struct
    |> Map.merge(Map.get(struct, extra_field, %{}))
    |> Map.reject(fn
      {key, _} when key in [:__struct__, extra_field] -> true
      {_key, value} -> is_nil(value)
    end)
    |> JSON.Encoder.Map.encode(encoder)
  end

  defmacro __using__(_) do
    quote do
      @behaviour Access

      @impl Access
      def fetch(struct, key), do: Map.fetch(struct, key)

      @impl Access
      def get_and_update(_, _, _), do: raise("#{inspect(__MODULE__)} is read-only")

      @impl Access
      def pop(_, _), do: raise("#{inspect(__MODULE__)} is read-only")
    end
  end
end

defmodule CeCe.Message do
  @moduledoc """
  Common message wrapper for all Claude Code CLI messages.

  All messages share these fields:
  - `type` - Message type: `:system`, `:assistant`, `:user`
  - `session_id` - Session UUID
  - `uuid` - Message UUID
  - `parent_tool_use_id` - Parent tool use ID (nil if not a tool response)
  - `payload` - Type-specific payload struct
  """

  @type message_type :: :system | :assistant | :user

  @type t :: %__MODULE__{
          type: message_type(),
          session_id: String.t(),
          uuid: String.t(),
          parent_tool_use_id: String.t() | nil,
          payload: struct()
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

  defp parse_type("system"), do: :system
  defp parse_type("assistant"), do: :assistant
  defp parse_type("user"), do: :user

  defp parse_payload(%{"type" => "system"} = json), do: CeCe.Payload.System.parse(json)
  defp parse_payload(%{"type" => "assistant"} = json), do: CeCe.Payload.Assistant.parse(json)
  defp parse_payload(%{"type" => "user"} = json), do: CeCe.Payload.User.parse(json)
end

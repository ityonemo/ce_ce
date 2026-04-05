defmodule CeCe.Payload.Outbound.ToolUseSummary do
  @moduledoc """
  Tool use summary message.

  Summary of a completed tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_use_id: String.t(),
          tool_name: String.t(),
          input: map(),
          output: String.t() | nil,
          error: String.t() | nil,
          is_error: boolean(),
          duration_ms: integer() | nil
        }

  defstruct [:tool_use_id, :tool_name, :input, :output, :error, :is_error, :duration_ms]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_use_id: json["tool_use_id"] || json["toolUseId"],
      tool_name: json["tool_name"] || json["toolName"],
      input: json["input"] || %{},
      output: json["output"],
      error: json["error"],
      is_error: json["is_error"] || json["isError"] || false,
      duration_ms: json["duration_ms"] || json["durationMs"]
    }
  end
end

defmodule CeCe.Payload.Outbound.ToolUseSummary do
  @moduledoc """
  Tool use summary message.

  Summary of a completed tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          toolUseId: String.t(),
          toolName: String.t(),
          input: map(),
          output: String.t() | nil,
          error: String.t() | nil,
          isError: boolean(),
          durationMs: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [:toolUseId, :toolName, :input, :output, :error, :isError, :durationMs]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: output, error, isError (defaults to false), durationMs
    %__MODULE__{
      toolUseId: Map.fetch!(json, "toolUseId"),
      toolName: Map.fetch!(json, "toolName"),
      input: Map.fetch!(json, "input"),
      output: Map.get(json, "output"),
      error: Map.get(json, "error"),
      isError: Map.get(json, "isError", false),
      durationMs: Map.get(json, "durationMs")
    }
  end
end

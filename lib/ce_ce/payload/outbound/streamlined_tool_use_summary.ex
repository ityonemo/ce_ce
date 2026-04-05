defmodule CeCe.Payload.Outbound.StreamlinedToolUseSummary do
  @moduledoc """
  Streamlined tool use summary message.

  Summary of tool usage in streamlined output mode.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          toolName: String.t(),
          toolInput: map(),
          toolOutput: String.t() | nil,
          toolError: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:toolName, :toolInput, :toolOutput, :toolError]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: toolOutput, toolError
    %__MODULE__{
      toolName: Map.fetch!(json, "toolName"),
      toolInput: Map.fetch!(json, "toolInput"),
      toolOutput: Map.get(json, "toolOutput"),
      toolError: Map.get(json, "toolError")
    }
  end
end

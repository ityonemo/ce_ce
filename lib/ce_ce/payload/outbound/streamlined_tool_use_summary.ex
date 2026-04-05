defmodule CeCe.Payload.Outbound.StreamlinedToolUseSummary do
  @moduledoc """
  Streamlined tool use summary message.

  Summary of tool usage in streamlined output mode.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_name: String.t(),
          tool_input: map(),
          tool_output: String.t() | nil,
          tool_error: String.t() | nil
        }

  defstruct [:tool_name, :tool_input, :tool_output, :tool_error]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_name: json["tool_name"] || json["toolName"],
      tool_input: json["tool_input"] || json["toolInput"] || %{},
      tool_output: json["tool_output"] || json["toolOutput"],
      tool_error: json["tool_error"] || json["toolError"]
    }
  end
end

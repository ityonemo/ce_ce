defmodule CeCe.Content.ToolResult do
  @moduledoc """
  Tool result content block.

  Represents the result of a tool execution in a user message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_use_id: String.t(),
          content: String.t() | [map()] | nil,
          is_error: boolean()
        }

  defstruct [:tool_use_id, :content, :is_error]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_use_id: json["tool_use_id"] || json["toolUseId"],
      content: json["content"],
      is_error: json["is_error"] || json["isError"] || false
    }
  end
end

defmodule CeCe.Content.ToolResult do
  @moduledoc """
  Tool result content block.

  Represents the result of a tool execution in a user message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          toolUseId: String.t(),
          content: String.t() | [map()] | nil,
          isError: boolean()
        }

  @derive JSON.Encoder
  defstruct [:toolUseId, :content, :isError]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: content, isError (defaults to false)
    %__MODULE__{
      toolUseId: Map.fetch!(json, "toolUseId"),
      content: Map.get(json, "content"),
      isError: Map.get(json, "isError", false)
    }
  end
end

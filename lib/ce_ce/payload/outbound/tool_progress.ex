defmodule CeCe.Payload.Outbound.ToolProgress do
  @moduledoc """
  Tool execution progress message.

  Reports progress during tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          toolUseId: String.t(),
          toolName: String.t(),
          progress: float() | nil,
          message: String.t() | nil,
          content: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:toolUseId, :toolName, :progress, :message, :content]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: progress, message, content
    %__MODULE__{
      toolUseId: Map.fetch!(json, "toolUseId"),
      toolName: Map.fetch!(json, "toolName"),
      progress: Map.get(json, "progress"),
      message: Map.get(json, "message"),
      content: Map.get(json, "content")
    }
  end
end

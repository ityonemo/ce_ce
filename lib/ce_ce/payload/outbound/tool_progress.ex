defmodule CeCe.Payload.Outbound.ToolProgress do
  @moduledoc """
  Tool execution progress message.

  Reports progress during tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_use_id: String.t(),
          tool_name: String.t(),
          progress: float() | nil,
          message: String.t() | nil,
          content: String.t() | nil
        }

  defstruct [:tool_use_id, :tool_name, :progress, :message, :content]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_use_id: json["tool_use_id"] || json["toolUseId"],
      tool_name: json["tool_name"] || json["toolName"],
      progress: json["progress"],
      message: json["message"],
      content: json["content"]
    }
  end
end

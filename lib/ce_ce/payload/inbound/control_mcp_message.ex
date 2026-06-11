defmodule CeCe.Payload.Inbound.ControlMcpMessage do
  @moduledoc """
  MCP message control request.

  Sends a message to an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :mcpMessage,
          serverName: String.t(),
          message: map()
        }

  @derive JSON.Encoder
  defstruct subtype: :mcpMessage, serverName: nil, message: %{}

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      serverName: Map.fetch!(json, "serverName"),
      message: Map.fetch!(json, "message")
    }
  end
end

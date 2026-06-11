defmodule CeCe.Payload.Inbound.ControlMcpReconnect do
  @moduledoc """
  MCP reconnect control request.

  Reconnects to an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :mcpReconnect,
          serverName: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :mcpReconnect, serverName: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: serverName
    %__MODULE__{
      serverName: Map.get(json, "serverName")
    }
  end
end

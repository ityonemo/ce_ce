defmodule CeCe.Payload.Inbound.ControlMcpSetServers do
  @moduledoc """
  MCP set servers control request.

  Configures the MCP servers.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :mcpSetServers,
          servers: [map()]
        }

  @derive JSON.Encoder
  defstruct subtype: :mcpSetServers, servers: []

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      servers: Map.fetch!(json, "servers")
    }
  end
end

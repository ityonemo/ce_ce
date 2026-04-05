defmodule CeCe.Payload.Inbound.ControlMcpSetServers do
  @moduledoc """
  MCP set servers control request.

  Configures the MCP servers.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          servers: [map()]
        }

  defstruct [:servers]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      servers: json["servers"] || []
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlMcpSetServers do
  def encode(struct, encoder) do
    %{
      "subtype" => "mcp_set_servers",
      "servers" => struct.servers
    }
    |> encoder.encode_map()
  end
end

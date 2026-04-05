defmodule CeCe.Payload.Inbound.ControlMcpToggle do
  @moduledoc """
  MCP toggle control request.

  Enables or disables an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          server_name: String.t(),
          enabled: boolean()
        }

  defstruct [:server_name, :enabled]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      server_name: json["server_name"] || json["serverName"],
      enabled: json["enabled"] || false
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlMcpToggle do
  def encode(struct, encoder) do
    %{
      "subtype" => "mcp_toggle",
      "server_name" => struct.server_name,
      "enabled" => struct.enabled
    }
    |> encoder.encode_map()
  end
end

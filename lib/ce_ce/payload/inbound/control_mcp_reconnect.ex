defmodule CeCe.Payload.Inbound.ControlMcpReconnect do
  @moduledoc """
  MCP reconnect control request.

  Reconnects to an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          server_name: String.t() | nil
        }

  defstruct [:server_name]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      server_name: json["server_name"] || json["serverName"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlMcpReconnect do
  def encode(struct, encoder) do
    map =
      %{"subtype" => "mcp_reconnect"}
      |> maybe_put("server_name", struct.server_name)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

defmodule CeCe.Payload.Inbound.ControlMcpMessage do
  @moduledoc """
  MCP message control request.

  Sends a message to an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          server_name: String.t(),
          message: map()
        }

  defstruct [:server_name, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      server_name: json["server_name"] || json["serverName"],
      message: json["message"] || %{}
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlMcpMessage do
  def encode(struct, encoder) do
    %{
      "subtype" => "mcp_message",
      "server_name" => struct.server_name,
      "message" => struct.message
    }
    |> encoder.encode_map()
  end
end

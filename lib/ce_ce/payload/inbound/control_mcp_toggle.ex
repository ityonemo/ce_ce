defmodule CeCe.Payload.Inbound.ControlMcpToggle do
  @moduledoc """
  MCP toggle control request.

  Enables or disables an MCP server.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :mcpToggle,
          serverName: String.t(),
          enabled: boolean()
        }

  @derive JSON.Encoder
  defstruct subtype: :mcpToggle, serverName: nil, enabled: false

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # enabled defaults to false
    %__MODULE__{
      serverName: Map.fetch!(json, "serverName"),
      enabled: Map.get(json, "enabled", false)
    }
  end
end

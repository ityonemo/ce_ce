defmodule CeCe.Payload.ControlRequest.McpServerName do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :mcp_reconnect | :mcp_toggle | :mcp_clear_auth,
          serverName: String.t(),
          enabled: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: nil, serverName: nil, enabled: nil

  @subtypes %{
    "mcp_reconnect" => :mcp_reconnect,
    "mcp_toggle" => :mcp_toggle,
    "mcp_clear_auth" => :mcp_clear_auth
  }

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(%{"subtype" => subtype} = json) do
    %__MODULE__{
      subtype: Map.fetch!(@subtypes, subtype),
      serverName: Map.fetch!(json, "serverName"),
      enabled: Map.get(json, "enabled")
    }
  end
end

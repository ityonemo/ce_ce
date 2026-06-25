defmodule CeCe.Payload.ControlRequest.McpSetServers do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :mcp_set_servers,
          servers: %{optional(String.t()) => json()}
        }

  @derive JSON.Encoder
  defstruct subtype: :mcp_set_servers, servers: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json), do: %__MODULE__{servers: Map.fetch!(json, "servers")}
end

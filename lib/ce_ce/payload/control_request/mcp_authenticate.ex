defmodule CeCe.Payload.ControlRequest.McpAuthenticate do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :mcp_authenticate,
          serverName: String.t(),
          redirectUri: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :mcp_authenticate, serverName: nil, redirectUri: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      serverName: Map.fetch!(json, "serverName"),
      redirectUri: Map.fetch!(json, "redirectUri")
    }
  end
end

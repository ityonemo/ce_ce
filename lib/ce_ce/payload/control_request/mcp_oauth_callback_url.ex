defmodule CeCe.Payload.ControlRequest.McpOAuthCallbackUrl do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :mcp_oauth_callback_url,
          serverName: String.t(),
          callbackUrl: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :mcp_oauth_callback_url, serverName: nil, callbackUrl: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      serverName: Map.fetch!(json, "serverName"),
      callbackUrl: Map.fetch!(json, "callbackUrl")
    }
  end
end

defmodule CeCe.Payload.ControlRequest.McpMessage do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :mcp_message,
          server_name: String.t(),
          message: json()
        }

  @derive JSON.Encoder
  defstruct subtype: :mcp_message, server_name: nil, message: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      server_name: Map.fetch!(json, "server_name"),
      message: Map.fetch!(json, "message")
    }
  end
end

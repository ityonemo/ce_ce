defmodule CeCe.Payload.Inbound.ControlMcpStatus do
  @moduledoc """
  MCP status control request.

  Requests the current status of MCP servers.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :mcpStatus
        }

  @derive JSON.Encoder
  defstruct subtype: :mcpStatus

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

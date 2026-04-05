defmodule CeCe.Payload.Inbound.ControlMcpStatus do
  @moduledoc """
  MCP status control request.

  Requests the current status of MCP servers.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{}

  defstruct []

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlMcpStatus do
  def encode(_struct, encoder) do
    %{"subtype" => "mcp_status"}
    |> encoder.encode_map()
  end
end

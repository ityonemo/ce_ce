defmodule CeCe.Payload.Inbound.ControlGetContextUsage do
  @moduledoc """
  Get context usage control request.

  Requests information about context window usage.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{}

  defstruct []

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlGetContextUsage do
  def encode(_struct, encoder) do
    %{"subtype" => "get_context_usage"}
    |> encoder.encode_map()
  end
end

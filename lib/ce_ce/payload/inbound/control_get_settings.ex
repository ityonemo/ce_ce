defmodule CeCe.Payload.Inbound.ControlGetSettings do
  @moduledoc """
  Get settings control request.

  Requests the current settings.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{}

  defstruct []

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlGetSettings do
  def encode(_struct, encoder) do
    %{"subtype" => "get_settings"}
    |> encoder.encode_map()
  end
end

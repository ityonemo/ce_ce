defmodule CeCe.Payload.Inbound.ControlReloadPlugins do
  @moduledoc """
  Reload plugins control request.

  Reloads the plugin configuration.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{}

  defstruct []

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlReloadPlugins do
  def encode(_struct, encoder) do
    %{"subtype" => "reload_plugins"}
    |> encoder.encode_map()
  end
end

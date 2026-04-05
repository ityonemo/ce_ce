defmodule CeCe.Payload.Inbound.ControlReloadPlugins do
  @moduledoc """
  Reload plugins control request.

  Reloads the plugin configuration.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :reloadPlugins
        }

  @derive JSON.Encoder
  defstruct subtype: :reloadPlugins

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

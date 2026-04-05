defmodule CeCe.Payload.Inbound.ControlGetSettings do
  @moduledoc """
  Get settings control request.

  Requests the current settings.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :getSettings
        }

  @derive JSON.Encoder
  defstruct subtype: :getSettings

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

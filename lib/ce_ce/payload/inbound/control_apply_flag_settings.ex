defmodule CeCe.Payload.Inbound.ControlApplyFlagSettings do
  @moduledoc """
  Apply flag settings control request.

  Applies configuration flag settings.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :applyFlagSettings,
          settings: map()
        }

  @derive JSON.Encoder
  defstruct subtype: :applyFlagSettings, settings: %{}

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      settings: Map.fetch!(json, "settings")
    }
  end
end

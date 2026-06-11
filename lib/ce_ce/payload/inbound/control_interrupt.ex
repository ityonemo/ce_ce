defmodule CeCe.Payload.Inbound.ControlInterrupt do
  @moduledoc """
  Interrupt control request.

  Interrupts the current operation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :interrupt,
          reason: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :interrupt, reason: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: reason
    %__MODULE__{
      reason: Map.get(json, "reason")
    }
  end
end

defmodule CeCe.Payload.ControlRequest.SetPermissionMode do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :set_permission_mode,
          mode: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :set_permission_mode, mode: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{mode: Map.fetch!(json, "mode")}
end

defmodule CeCe.Payload.ControlRequest.ApplyFlagSettings do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :apply_flag_settings,
          settings: json()
        }

  @derive JSON.Encoder
  defstruct subtype: :apply_flag_settings, settings: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json), do: %__MODULE__{settings: Map.fetch!(json, "settings")}
end

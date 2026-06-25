defmodule CeCe.Payload.ControlRequest.UltrareviewLaunch do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :ultrareview_launch,
          args: json(),
          confirm: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :ultrareview_launch, args: %{}, confirm: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      args: Map.fetch!(json, "args"),
      confirm: Map.get(json, "confirm")
    }
  end
end

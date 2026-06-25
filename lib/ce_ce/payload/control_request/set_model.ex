defmodule CeCe.Payload.ControlRequest.SetModel do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :set_model,
          model: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :set_model, model: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{model: Map.fetch!(json, "model")}
end

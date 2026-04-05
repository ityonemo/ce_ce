defmodule CeCe.Payload.Inbound.ControlSetModel do
  @moduledoc """
  Set model control request.

  Changes the model used for generation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :setModel,
          model: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :setModel, model: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      model: Map.fetch!(json, "model")
    }
  end
end

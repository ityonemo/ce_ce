defmodule CeCe.Payload.ControlRequest.GenerateSessionTitle do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :generate_session_title,
          description: String.t(),
          persist: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :generate_session_title, description: nil, persist: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      description: Map.fetch!(json, "description"),
      persist: Map.get(json, "persist")
    }
  end
end

defmodule CeCe.Payload.Inbound.ControlElicitation do
  @moduledoc """
  Elicitation control request.

  Responds to an elicitation (user input request).
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :elicitation,
          elicitationId: String.t(),
          response: map() | nil,
          cancelled: boolean()
        }

  @derive JSON.Encoder
  defstruct subtype: :elicitation, elicitationId: nil, response: nil, cancelled: false

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: response; cancelled defaults to false
    %__MODULE__{
      elicitationId: Map.fetch!(json, "elicitationId"),
      response: Map.get(json, "response"),
      cancelled: Map.get(json, "cancelled", false)
    }
  end
end

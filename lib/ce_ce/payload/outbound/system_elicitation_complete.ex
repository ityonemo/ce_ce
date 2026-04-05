defmodule CeCe.Payload.Outbound.SystemElicitationComplete do
  @moduledoc """
  Elicitation complete message.

  Indicates an elicitation (user input request) has completed.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          elicitationId: String.t(),
          response: map() | nil,
          cancelled: boolean()
        }

  @derive JSON.Encoder
  defstruct [:elicitationId, :response, :cancelled]

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

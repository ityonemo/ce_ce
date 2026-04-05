defmodule CeCe.Payload.Outbound.SystemElicitationComplete do
  @moduledoc """
  Elicitation complete message.

  Indicates an elicitation (user input request) has completed.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          elicitation_id: String.t(),
          response: map() | nil,
          cancelled: boolean()
        }

  defstruct [:elicitation_id, :response, :cancelled]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      elicitation_id: json["elicitation_id"] || json["elicitationId"],
      response: json["response"],
      cancelled: json["cancelled"] || false
    }
  end
end

defmodule CeCe.Payload.Inbound.ControlElicitation do
  @moduledoc """
  Elicitation control request.

  Responds to an elicitation (user input request).
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

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlElicitation do
  def encode(struct, encoder) do
    map =
      %{
        "subtype" => "elicitation",
        "elicitation_id" => struct.elicitation_id,
        "cancelled" => struct.cancelled
      }
      |> maybe_put("response", struct.response)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

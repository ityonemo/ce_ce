defmodule CeCe.Payload.Inbound.ControlInterrupt do
  @moduledoc """
  Interrupt control request.

  Interrupts the current operation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          reason: String.t() | nil
        }

  defstruct [:reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      reason: json["reason"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlInterrupt do
  def encode(struct, encoder) do
    map =
      %{"subtype" => "interrupt"}
      |> maybe_put("reason", struct.reason)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

defmodule CeCe.Payload.Inbound.ControlCanUseTool do
  @moduledoc """
  Can use tool control request.

  Responds to a tool permission request.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_use_id: String.t(),
          allowed: boolean(),
          reason: String.t() | nil
        }

  defstruct [:tool_use_id, :allowed, :reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_use_id: json["tool_use_id"] || json["toolUseId"],
      allowed: json["allowed"] || false,
      reason: json["reason"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlCanUseTool do
  def encode(struct, encoder) do
    map =
      %{
        "subtype" => "can_use_tool",
        "tool_use_id" => struct.tool_use_id,
        "allowed" => struct.allowed
      }
      |> maybe_put("reason", struct.reason)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

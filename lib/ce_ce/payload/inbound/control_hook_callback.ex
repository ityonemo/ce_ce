defmodule CeCe.Payload.Inbound.ControlHookCallback do
  @moduledoc """
  Hook callback control request.

  Response to a hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hook_id: String.t(),
          result: map() | nil,
          error: String.t() | nil
        }

  defstruct [:hook_id, :result, :error]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      hook_id: json["hook_id"] || json["hookId"],
      result: json["result"],
      error: json["error"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlHookCallback do
  def encode(struct, encoder) do
    map =
      %{
        "subtype" => "hook_callback",
        "hook_id" => struct.hook_id
      }
      |> maybe_put("result", struct.result)
      |> maybe_put("error", struct.error)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

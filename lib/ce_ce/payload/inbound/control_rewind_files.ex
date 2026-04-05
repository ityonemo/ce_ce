defmodule CeCe.Payload.Inbound.ControlRewindFiles do
  @moduledoc """
  Rewind files control request.

  Reverts files to a previous state.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          files: [String.t()],
          to_message_id: String.t() | nil
        }

  defstruct [:files, :to_message_id]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      files: json["files"] || [],
      to_message_id: json["to_message_id"] || json["toMessageId"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlRewindFiles do
  def encode(struct, encoder) do
    map =
      %{
        "subtype" => "rewind_files",
        "files" => struct.files
      }
      |> maybe_put("to_message_id", struct.to_message_id)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

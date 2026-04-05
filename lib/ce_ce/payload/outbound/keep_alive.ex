defmodule CeCe.Payload.Outbound.KeepAlive do
  @moduledoc """
  Heartbeat message (bidirectional).

  Sent periodically to keep the connection alive.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          timestamp: String.t() | nil
        }

  defstruct [:timestamp]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      timestamp: json["timestamp"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Outbound.KeepAlive do
  def encode(struct, encoder) do
    map = %{"type" => "keep_alive"}

    map =
      if struct.timestamp do
        Map.put(map, "timestamp", struct.timestamp)
      else
        map
      end

    encoder.encode_map(map)
  end
end

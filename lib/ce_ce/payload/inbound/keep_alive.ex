defmodule CeCe.Payload.Inbound.KeepAlive do
  @moduledoc """
  Heartbeat message (bidirectional).

  Sent periodically to keep the connection alive.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: :keepAlive,
          timestamp: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct type: :keepAlive, timestamp: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: timestamp
    %__MODULE__{
      timestamp: Map.get(json, "timestamp")
    }
  end
end

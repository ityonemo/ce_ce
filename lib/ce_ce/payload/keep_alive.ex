defmodule CeCe.Payload.KeepAlive do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields []

  @type t :: %__MODULE__{
          type: :keep_alive,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          timestamp: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [:session_id, :uuid, :parent_tool_use_id, :timestamp, type: :keep_alive]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      timestamp: Map.get(json, "timestamp")
    }
  end
end

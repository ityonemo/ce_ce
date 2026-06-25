defmodule CeCe.Payload.ControlCancelRequest do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:request_id]

  @type t :: %__MODULE__{
          type: :control_cancel_request,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          request_id: String.t()
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [:session_id, :uuid, :parent_tool_use_id, type: :control_cancel_request]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      request_id: Map.fetch!(json, "request_id")
    }
  end
end

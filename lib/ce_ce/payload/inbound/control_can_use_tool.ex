defmodule CeCe.Payload.Inbound.ControlCanUseTool do
  @moduledoc """
  Can use tool control request.

  Responds to a tool permission request.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :canUseTool,
          toolUseId: String.t(),
          allowed: boolean(),
          reason: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :canUseTool, toolUseId: nil, allowed: false, reason: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: reason; allowed defaults to false
    %__MODULE__{
      toolUseId: Map.fetch!(json, "toolUseId"),
      allowed: Map.get(json, "allowed", false),
      reason: Map.get(json, "reason")
    }
  end
end

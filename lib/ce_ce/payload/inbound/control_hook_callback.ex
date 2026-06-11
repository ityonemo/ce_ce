defmodule CeCe.Payload.Inbound.ControlHookCallback do
  @moduledoc """
  Hook callback control request.

  Response to a hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :hookCallback,
          hookId: String.t(),
          result: map() | nil,
          error: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :hookCallback, hookId: nil, result: nil, error: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: result, error
    %__MODULE__{
      hookId: Map.fetch!(json, "hookId"),
      result: Map.get(json, "result"),
      error: Map.get(json, "error")
    }
  end
end

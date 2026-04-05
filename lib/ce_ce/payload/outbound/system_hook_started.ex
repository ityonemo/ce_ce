defmodule CeCe.Payload.Outbound.SystemHookStarted do
  @moduledoc """
  Hook started message.

  Indicates a hook has begun execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hookName: String.t(),
          hookType: String.t() | nil,
          context: map()
        }

  @derive JSON.Encoder
  defstruct [:hookName, :hookType, :context]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: hookType
    %__MODULE__{
      hookName: Map.fetch!(json, "hookName"),
      hookType: Map.get(json, "hookType"),
      context: Map.fetch!(json, "context")
    }
  end
end

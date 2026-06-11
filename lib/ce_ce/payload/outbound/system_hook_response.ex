defmodule CeCe.Payload.Outbound.SystemHookResponse do
  @moduledoc """
  Hook response message.

  Result of a completed hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hookName: String.t(),
          success: boolean(),
          output: String.t() | nil,
          error: String.t() | nil,
          durationMs: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [:hookName, :success, :output, :error, :durationMs]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: output, error, durationMs; success defaults to false
    %__MODULE__{
      hookName: Map.fetch!(json, "hookName"),
      success: Map.get(json, "success", false),
      output: Map.get(json, "output"),
      error: Map.get(json, "error"),
      durationMs: Map.get(json, "durationMs")
    }
  end
end

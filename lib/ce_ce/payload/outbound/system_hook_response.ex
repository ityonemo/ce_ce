defmodule CeCe.Payload.Outbound.SystemHookResponse do
  @moduledoc """
  Hook response message.

  Result of a completed hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hook_name: String.t(),
          success: boolean(),
          output: String.t() | nil,
          error: String.t() | nil,
          duration_ms: integer() | nil
        }

  defstruct [:hook_name, :success, :output, :error, :duration_ms]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      hook_name: json["hook_name"] || json["hookName"],
      success: json["success"] || false,
      output: json["output"],
      error: json["error"],
      duration_ms: json["duration_ms"] || json["durationMs"]
    }
  end
end

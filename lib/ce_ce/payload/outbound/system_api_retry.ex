defmodule CeCe.Payload.Outbound.SystemApiRetry do
  @moduledoc """
  API retry message.

  Indicates an API request is being retried.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          attempt: integer(),
          maxAttempts: integer() | nil,
          delayMs: integer() | nil,
          reason: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:attempt, :maxAttempts, :delayMs, :reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: maxAttempts, delayMs, reason
    %__MODULE__{
      attempt: Map.fetch!(json, "attempt"),
      maxAttempts: Map.get(json, "maxAttempts"),
      delayMs: Map.get(json, "delayMs"),
      reason: Map.get(json, "reason")
    }
  end
end

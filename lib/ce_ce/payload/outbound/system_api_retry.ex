defmodule CeCe.Payload.Outbound.SystemApiRetry do
  @moduledoc """
  API retry message.

  Indicates an API request is being retried.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          attempt: integer(),
          max_attempts: integer() | nil,
          delay_ms: integer() | nil,
          reason: String.t() | nil
        }

  defstruct [:attempt, :max_attempts, :delay_ms, :reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      attempt: json["attempt"],
      max_attempts: json["max_attempts"] || json["maxAttempts"],
      delay_ms: json["delay_ms"] || json["delayMs"],
      reason: json["reason"]
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemPostTurnSummary do
  @moduledoc """
  Post-turn summary message.

  Summary information after a conversation turn completes.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          turn_number: integer() | nil,
          usage: Usage.t() | nil,
          duration_ms: integer() | nil,
          cost_usd: float() | nil
        }

  defstruct [:turn_number, :usage, :duration_ms, :cost_usd]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      turn_number: json["turn_number"] || json["turnNumber"],
      usage: Usage.parse(json["usage"]),
      duration_ms: json["duration_ms"] || json["durationMs"],
      cost_usd: json["cost_usd"] || json["costUsd"]
    }
  end
end

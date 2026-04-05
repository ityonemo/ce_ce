defmodule CeCe.Payload.Outbound.SystemPostTurnSummary do
  @moduledoc """
  Post-turn summary message.

  Summary information after a conversation turn completes.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          turnNumber: integer() | nil,
          usage: Usage.t() | nil,
          durationMs: integer() | nil,
          costUsd: float() | nil
        }

  @derive JSON.Encoder
  defstruct [:turnNumber, :usage, :durationMs, :costUsd]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # All fields are optional
    %__MODULE__{
      turnNumber: Map.get(json, "turnNumber"),
      usage: Usage.parse(Map.get(json, "usage")),
      durationMs: Map.get(json, "durationMs"),
      costUsd: Map.get(json, "costUsd")
    }
  end
end

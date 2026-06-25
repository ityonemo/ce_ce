defmodule CeCe.Payload.Unknown do
  @moduledoc """
  Catch-all payload for message types not yet modeled by ce_ce.

  The Claude Code CLI occasionally introduces new top-level message types
  ahead of the documented stream schema (e.g. `rate_limit_event`). Rather
  than crash on the first unrecognized `type`, `CeCe.Payload.parse/1`
  routes it here, preserving the raw map in `extra` so it can still be
  delivered, logged, or inspected. A `Logger.warning` is emitted at the
  dispatch site so unmodeled types surface in logs.
  """

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: String.t(),
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct [:type, :session_id, :uuid, extra: %{}]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      type: Map.fetch!(json, "type"),
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      extra: Map.drop(json, ["type", "session_id", "uuid"])
    }
  end

  defimpl JSON.Encoder do
    def encode(payload, encoder), do: CeCe.Payload._encode_json_merging(payload, :extra, encoder)
  end
end

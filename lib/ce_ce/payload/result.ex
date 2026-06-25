defmodule CeCe.Payload.Result do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields []

  @type t :: %__MODULE__{
          type: :result,
          subtype: String.t() | nil,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          is_error: boolean() | nil,
          result: String.t() | nil,
          errors: [String.t()] | nil,
          total_cost_usd: number() | nil,
          duration_ms: number() | nil,
          duration_api_ms: number() | nil,
          num_turns: number() | nil,
          usage: map() | nil
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [
                :subtype,
                :session_id,
                :uuid,
                :is_error,
                :result,
                :errors,
                :total_cost_usd,
                :duration_ms,
                :duration_api_ms,
                :num_turns,
                :usage,
                type: :result
              ]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      subtype: Map.get(json, "subtype"),
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      is_error: Map.get(json, "is_error"),
      result: Map.get(json, "result"),
      errors: Map.get(json, "errors"),
      total_cost_usd: Map.get(json, "total_cost_usd"),
      duration_ms: Map.get(json, "duration_ms"),
      duration_api_ms: Map.get(json, "duration_api_ms"),
      num_turns: Map.get(json, "num_turns"),
      usage: Map.get(json, "usage")
    }
  end
end

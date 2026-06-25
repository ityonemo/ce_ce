defmodule CeCe.Payload.RateLimitEvent.RateLimitInfo do
  @moduledoc """
  Rate-limit details carried by a `rate_limit_event` message.

  Fields are reverse-engineered from the Claude Code VS Code extension
  (the only documented consumer): the webview's rate-limit warning
  formatter reads `status`, `rateLimitType`, `resetsAt`, `utilization`,
  and `overageInUse`. Inner keys are camelCase exactly as the CLI emits
  them; any additional keys the producer sends are preserved in `extra`.
  """

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          status: String.t(),
          rateLimitType: String.t() | nil,
          resetsAt: number() | nil,
          utilization: number() | nil,
          overageInUse: boolean() | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct status: nil,
            rateLimitType: nil,
            resetsAt: nil,
            utilization: nil,
            overageInUse: nil,
            extra: %{}

  @known ~w[status rateLimitType resetsAt utilization overageInUse]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      status: Map.fetch!(json, "status"),
      rateLimitType: Map.get(json, "rateLimitType"),
      resetsAt: Map.get(json, "resetsAt"),
      utilization: Map.get(json, "utilization"),
      overageInUse: Map.get(json, "overageInUse"),
      extra: Map.drop(json, @known)
    }
  end

  defimpl JSON.Encoder do
    def encode(info, encoder), do: CeCe.Payload._encode_json_merging(info, :extra, encoder)
  end
end

defmodule CeCe.Payload.ControlRequest.SetMaxThinkingTokens do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :set_max_thinking_tokens,
          max_thinking_tokens: number()
        }

  @derive JSON.Encoder
  defstruct subtype: :set_max_thinking_tokens, max_thinking_tokens: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{max_thinking_tokens: Map.fetch!(json, "max_thinking_tokens")}
end

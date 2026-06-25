defmodule CeCe.Payload.Assistant.ThinkingContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :thinking | :redacted_thinking,
          thinking: String.t() | nil,
          text: String.t() | nil,
          signature: String.t() | nil,
          data: String.t() | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :thinking, thinking: nil, text: nil, signature: nil, data: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      type: normalize_type(Map.fetch!(json, "type")),
      thinking: Map.get(json, "thinking"),
      text: Map.get(json, "text"),
      signature: Map.get(json, "signature"),
      data: Map.get(json, "data"),
      extra: Map.drop(json, ["type", "thinking", "text", "signature", "data"])
    }
  end

  defp normalize_type("thinking"), do: :thinking
  defp normalize_type("redacted_thinking"), do: :redacted_thinking

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

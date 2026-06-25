defmodule CeCe.Payload.Common.TextContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :text,
          text: String.t(),
          annotations: json() | nil,
          _meta: %{optional(String.t()) => json()} | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :text, text: nil, annotations: nil, _meta: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      text: Map.fetch!(json, "text"),
      annotations: Map.get(json, "annotations"),
      _meta: Map.get(json, "_meta"),
      extra: Map.drop(json, ["type", "text", "annotations", "_meta"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

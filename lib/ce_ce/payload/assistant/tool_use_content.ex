defmodule CeCe.Payload.Assistant.ToolUseContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :tool_use,
          id: String.t(),
          name: String.t(),
          input: %{optional(String.t()) => json()} | nil,
          _meta: %{optional(String.t()) => json()} | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :tool_use, id: nil, name: nil, input: %{}, _meta: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      id: Map.fetch!(json, "id"),
      name: Map.fetch!(json, "name"),
      input: Map.fetch!(json, "input"),
      _meta: Map.get(json, "_meta"),
      extra: Map.drop(json, ["type", "id", "name", "input", "_meta"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

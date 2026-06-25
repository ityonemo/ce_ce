defmodule CeCe.Payload.Common.UnknownContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: String.t(),
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      type: Map.fetch!(json, "type"),
      extra: Map.drop(json, ["type"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

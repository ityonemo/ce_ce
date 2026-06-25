defmodule CeCe.Payload.User.AudioContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :audio,
          data: String.t(),
          mimeType: String.t(),
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :audio, data: nil, mimeType: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      data: Map.fetch!(json, "data"),
      mimeType: Map.fetch!(json, "mimeType"),
      extra: Map.drop(json, ["type", "data", "mimeType"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

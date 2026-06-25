defmodule CeCe.Payload.User.ResourceContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :resource,
          resource: json() | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :resource, resource: nil, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      resource: Map.fetch!(json, "resource"),
      extra: Map.drop(json, ["type", "resource"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

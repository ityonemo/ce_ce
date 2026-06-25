defmodule CeCe.Payload.User.ResourceLinkContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :resource_link,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :resource_link, extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      extra: Map.drop(json, ["type"])
    }
  end

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

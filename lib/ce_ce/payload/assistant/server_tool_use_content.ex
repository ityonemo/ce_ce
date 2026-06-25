defmodule CeCe.Payload.Assistant.ServerToolUseContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :server_tool_use,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :server_tool_use, extra: %{}

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

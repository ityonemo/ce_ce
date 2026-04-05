defmodule CeCe.Payload.Inbound.ControlSetMaxThinkingTokens do
  @moduledoc """
  Set max thinking tokens control request.

  Sets the maximum number of tokens for thinking.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          max_tokens: integer()
        }

  defstruct [:max_tokens]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      max_tokens: json["max_tokens"] || json["maxTokens"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlSetMaxThinkingTokens do
  def encode(struct, encoder) do
    %{
      "subtype" => "set_max_thinking_tokens",
      "max_tokens" => struct.max_tokens
    }
    |> encoder.encode_map()
  end
end

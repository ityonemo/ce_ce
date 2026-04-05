defmodule CeCe.Payload.Inbound.ControlSetMaxThinkingTokens do
  @moduledoc """
  Set max thinking tokens control request.

  Sets the maximum number of tokens for thinking.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :setMaxThinkingTokens,
          maxTokens: integer()
        }

  @derive JSON.Encoder
  defstruct subtype: :setMaxThinkingTokens, maxTokens: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      maxTokens: Map.fetch!(json, "maxTokens")
    }
  end
end

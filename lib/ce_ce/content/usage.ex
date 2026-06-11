defmodule CeCe.Content.Usage do
  @moduledoc """
  Token usage statistics.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          inputTokens: integer() | nil,
          outputTokens: integer() | nil,
          cacheCreationInputTokens: integer() | nil,
          cacheReadInputTokens: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [
    :inputTokens,
    :outputTokens,
    :cacheCreationInputTokens,
    :cacheReadInputTokens
  ]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # All fields are optional
    %__MODULE__{
      inputTokens: Map.get(json, "inputTokens"),
      outputTokens: Map.get(json, "outputTokens"),
      cacheCreationInputTokens: Map.get(json, "cacheCreationInputTokens"),
      cacheReadInputTokens: Map.get(json, "cacheReadInputTokens")
    }
  end
end

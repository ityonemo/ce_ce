defmodule CeCe.Payload.Outbound.PromptSuggestion do
  @moduledoc """
  Prompt suggestion message.

  Suggestions for follow-up prompts.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          suggestions: [String.t()]
        }

  @derive JSON.Encoder
  defstruct [:suggestions]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      suggestions: Map.fetch!(json, "suggestions")
    }
  end
end

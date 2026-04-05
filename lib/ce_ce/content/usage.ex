defmodule CeCe.Content.Usage do
  @moduledoc """
  Token usage statistics.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          input_tokens: integer() | nil,
          output_tokens: integer() | nil,
          cache_creation_input_tokens: integer() | nil,
          cache_read_input_tokens: integer() | nil
        }

  defstruct [
    :input_tokens,
    :output_tokens,
    :cache_creation_input_tokens,
    :cache_read_input_tokens
  ]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      input_tokens: json["input_tokens"],
      output_tokens: json["output_tokens"],
      cache_creation_input_tokens: json["cache_creation_input_tokens"],
      cache_read_input_tokens: json["cache_read_input_tokens"]
    }
  end
end

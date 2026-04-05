defmodule CeCe.Content.ModelInfo do
  @moduledoc """
  Model information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t() | nil,
          max_tokens: integer() | nil
        }

  defstruct [:id, :name, :max_tokens]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_binary(json) do
    %__MODULE__{
      id: json,
      name: nil,
      max_tokens: nil
    }
  end

  def parse(json) when is_map(json) do
    %__MODULE__{
      id: json["id"],
      name: json["name"],
      max_tokens: json["max_tokens"] || json["maxTokens"]
    }
  end

  @doc "Parse a list of models."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

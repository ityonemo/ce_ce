defmodule CeCe.Content.ModelInfo do
  @moduledoc """
  Model information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t() | nil,
          maxTokens: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [:id, :name, :maxTokens]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_binary(json) do
    %__MODULE__{
      id: json,
      name: nil,
      maxTokens: nil
    }
  end

  def parse(json) when is_map(json) do
    # Optional: name, maxTokens
    %__MODULE__{
      id: Map.fetch!(json, "id"),
      name: Map.get(json, "name"),
      maxTokens: Map.get(json, "maxTokens")
    }
  end

  @doc "Parse a list of models."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

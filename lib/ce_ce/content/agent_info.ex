defmodule CeCe.Content.AgentInfo do
  @moduledoc """
  Agent information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t() | nil,
          type: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:name, :description, :type]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_binary(json) do
    %__MODULE__{
      name: json,
      description: nil,
      type: nil
    }
  end

  def parse(json) when is_map(json) do
    # Optional: description, type
    %__MODULE__{
      name: Map.fetch!(json, "name"),
      description: Map.get(json, "description"),
      type: Map.get(json, "type")
    }
  end

  @doc "Parse a list of agents."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

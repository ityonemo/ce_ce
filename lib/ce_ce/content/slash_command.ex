defmodule CeCe.Content.SlashCommand do
  @moduledoc """
  Slash command information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t() | nil,
          args: [String.t()]
        }

  defstruct [:name, :description, :args]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_binary(json) do
    %__MODULE__{
      name: json,
      description: nil,
      args: []
    }
  end

  def parse(json) when is_map(json) do
    %__MODULE__{
      name: json["name"],
      description: json["description"],
      args: json["args"] || []
    }
  end

  @doc "Parse a list of slash commands."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

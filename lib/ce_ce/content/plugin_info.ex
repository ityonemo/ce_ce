defmodule CeCe.Content.PluginInfo do
  @moduledoc """
  Plugin information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t() | nil,
          enabled: boolean()
        }

  @derive JSON.Encoder
  defstruct [:name, :description, :enabled]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_binary(json) do
    %__MODULE__{
      name: json,
      description: nil,
      enabled: true
    }
  end

  def parse(json) when is_map(json) do
    # Optional: description, enabled (defaults to true)
    %__MODULE__{
      name: Map.fetch!(json, "name"),
      description: Map.get(json, "description"),
      enabled: Map.get(json, "enabled", true)
    }
  end

  @doc "Parse a list of plugins."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

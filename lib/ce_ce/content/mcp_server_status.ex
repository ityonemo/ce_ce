defmodule CeCe.Content.McpServerStatus do
  @moduledoc """
  MCP server status information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          name: String.t(),
          status: String.t(),
          error: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:name, :status, :error]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # Optional: error
    %__MODULE__{
      name: Map.fetch!(json, "name"),
      status: Map.fetch!(json, "status"),
      error: Map.get(json, "error")
    }
  end

  @doc "Parse a list of MCP server status entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

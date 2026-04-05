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

  defstruct [:name, :status, :error]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      name: json["name"],
      status: json["status"],
      error: json["error"]
    }
  end

  @doc "Parse a list of MCP server status entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

defmodule CeCe.Content.PermissionDenial do
  @moduledoc """
  Permission denial record.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          tool_name: String.t(),
          reason: String.t() | nil,
          timestamp: String.t() | nil
        }

  defstruct [:tool_name, :reason, :timestamp]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      tool_name: json["tool_name"] || json["toolName"],
      reason: json["reason"],
      timestamp: json["timestamp"]
    }
  end

  @doc "Parse a list of permission denials."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

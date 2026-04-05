defmodule CeCe.Content.PermissionDenial do
  @moduledoc """
  Permission denial record.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          toolName: String.t(),
          reason: String.t() | nil,
          timestamp: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:toolName, :reason, :timestamp]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # Optional: reason, timestamp
    %__MODULE__{
      toolName: Map.fetch!(json, "toolName"),
      reason: Map.get(json, "reason"),
      timestamp: Map.get(json, "timestamp")
    }
  end

  @doc "Parse a list of permission denials."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

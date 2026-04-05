defmodule CeCe.Content.ModelUsage do
  @moduledoc """
  Per-model usage breakdown.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          model: String.t(),
          usage: Usage.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:model, :usage]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # Optional: usage
    %__MODULE__{
      model: Map.fetch!(json, "model"),
      usage: Usage.parse(Map.get(json, "usage"))
    }
  end

  @doc "Parse a list of model usage entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

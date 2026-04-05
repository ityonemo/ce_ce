defmodule CeCe.Content.ModelUsage do
  @moduledoc """
  Per-model usage breakdown.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          model: String.t(),
          usage: Usage.t()
        }

  defstruct [:model, :usage]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      model: json["model"],
      usage: Usage.parse(json["usage"])
    }
  end

  @doc "Parse a list of model usage entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

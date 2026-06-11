defmodule CeCe.Content.TaskUsage do
  @moduledoc """
  Task usage statistics.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          taskId: String.t(),
          usage: Usage.t()
        }

  @derive JSON.Encoder
  defstruct [:taskId, :usage]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # Optional: usage
    %__MODULE__{
      taskId: Map.fetch!(json, "taskId"),
      usage: Usage.parse(Map.get(json, "usage"))
    }
  end

  @doc "Parse a list of task usage entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

defmodule CeCe.Content.TaskUsage do
  @moduledoc """
  Task usage statistics.
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          task_id: String.t(),
          usage: Usage.t()
        }

  defstruct [:task_id, :usage]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      task_id: json["task_id"] || json["taskId"],
      usage: Usage.parse(json["usage"])
    }
  end

  @doc "Parse a list of task usage entries."
  def parse_list(nil), do: []

  def parse_list(list) when is_list(list) do
    Enum.map(list, &parse/1)
  end
end

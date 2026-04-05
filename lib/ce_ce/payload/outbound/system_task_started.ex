defmodule CeCe.Payload.Outbound.SystemTaskStarted do
  @moduledoc """
  Task started message.

  Indicates a background task has begun.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          task_id: String.t(),
          task_type: String.t() | nil,
          description: String.t() | nil
        }

  defstruct [:task_id, :task_type, :description]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      task_id: json["task_id"] || json["taskId"],
      task_type: json["task_type"] || json["taskType"],
      description: json["description"]
    }
  end
end

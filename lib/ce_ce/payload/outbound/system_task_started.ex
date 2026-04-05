defmodule CeCe.Payload.Outbound.SystemTaskStarted do
  @moduledoc """
  Task started message.

  Indicates a background task has begun.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          taskId: String.t(),
          taskType: String.t() | nil,
          description: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:taskId, :taskType, :description]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: taskType, description
    %__MODULE__{
      taskId: Map.fetch!(json, "taskId"),
      taskType: Map.get(json, "taskType"),
      description: Map.get(json, "description")
    }
  end
end

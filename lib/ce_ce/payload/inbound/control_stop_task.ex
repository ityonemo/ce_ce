defmodule CeCe.Payload.Inbound.ControlStopTask do
  @moduledoc """
  Stop task control request.

  Stops a running background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :stopTask,
          taskId: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :stopTask, taskId: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      taskId: Map.fetch!(json, "taskId")
    }
  end
end

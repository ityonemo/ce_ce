defmodule CeCe.Payload.Inbound.ControlStopTask do
  @moduledoc """
  Stop task control request.

  Stops a running background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          task_id: String.t()
        }

  defstruct [:task_id]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      task_id: json["task_id"] || json["taskId"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlStopTask do
  def encode(struct, encoder) do
    %{
      "subtype" => "stop_task",
      "task_id" => struct.task_id
    }
    |> encoder.encode_map()
  end
end

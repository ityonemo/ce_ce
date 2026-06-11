defmodule CeCe.Payload.Outbound.SystemTaskProgress do
  @moduledoc """
  Task progress message.

  Reports progress of a background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          taskId: String.t(),
          progress: float() | nil,
          message: String.t() | nil,
          current: integer() | nil,
          total: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [:taskId, :progress, :message, :current, :total]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: progress, message, current, total
    %__MODULE__{
      taskId: Map.fetch!(json, "taskId"),
      progress: Map.get(json, "progress"),
      message: Map.get(json, "message"),
      current: Map.get(json, "current"),
      total: Map.get(json, "total")
    }
  end
end

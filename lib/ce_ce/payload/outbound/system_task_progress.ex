defmodule CeCe.Payload.Outbound.SystemTaskProgress do
  @moduledoc """
  Task progress message.

  Reports progress of a background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          task_id: String.t(),
          progress: float() | nil,
          message: String.t() | nil,
          current: integer() | nil,
          total: integer() | nil
        }

  defstruct [:task_id, :progress, :message, :current, :total]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      task_id: json["task_id"] || json["taskId"],
      progress: json["progress"],
      message: json["message"],
      current: json["current"],
      total: json["total"]
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemTaskNotification do
  @moduledoc """
  Task notification message.

  General notification about a background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          taskId: String.t(),
          notificationType: String.t() | nil,
          message: String.t() | nil,
          details: map()
        }

  @derive JSON.Encoder
  defstruct [:taskId, :notificationType, :message, :details]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: notificationType, message
    %__MODULE__{
      taskId: Map.fetch!(json, "taskId"),
      notificationType: Map.get(json, "notificationType"),
      message: Map.get(json, "message"),
      details: Map.fetch!(json, "details")
    }
  end
end

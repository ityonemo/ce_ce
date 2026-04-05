defmodule CeCe.Payload.Outbound.SystemTaskNotification do
  @moduledoc """
  Task notification message.

  General notification about a background task.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          task_id: String.t(),
          notification_type: String.t() | nil,
          message: String.t() | nil,
          details: map()
        }

  defstruct [:task_id, :notification_type, :message, :details]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      task_id: json["task_id"] || json["taskId"],
      notification_type: json["notification_type"] || json["notificationType"],
      message: json["message"],
      details: json["details"] || %{}
    }
  end
end

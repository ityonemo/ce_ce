defmodule CeCe.Payload.Outbound.ControlResponse do
  @moduledoc """
  Control response message.

  Response to a control request.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          request_id: String.t() | nil,
          success: boolean(),
          error: String.t() | nil,
          data: map() | nil
        }

  defstruct [:request_id, :success, :error, :data]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      request_id: json["request_id"] || json["requestId"],
      success: json["success"] || false,
      error: json["error"],
      data: json["data"]
    }
  end
end

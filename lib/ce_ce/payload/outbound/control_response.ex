defmodule CeCe.Payload.Outbound.ControlResponse do
  @moduledoc """
  Control response message.

  Response to a control request.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          requestId: String.t() | nil,
          success: boolean(),
          error: String.t() | nil,
          data: map() | nil
        }

  @derive JSON.Encoder
  defstruct [:requestId, :success, :error, :data]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: requestId, error, data; success defaults to false
    %__MODULE__{
      requestId: Map.get(json, "requestId"),
      success: Map.get(json, "success", false),
      error: Map.get(json, "error"),
      data: Map.get(json, "data")
    }
  end
end

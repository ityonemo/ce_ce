defmodule CeCe.Payload.Outbound.SystemStatus do
  @moduledoc """
  System status message.

  Reports current system status and state.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          status: String.t(),
          message: String.t() | nil,
          details: map()
        }

  @derive JSON.Encoder
  defstruct [:status, :message, :details]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: message
    %__MODULE__{
      status: Map.fetch!(json, "status"),
      message: Map.get(json, "message"),
      details: Map.fetch!(json, "details")
    }
  end
end

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

  defstruct [:status, :message, :details]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      status: json["status"],
      message: json["message"],
      details: json["details"] || %{}
    }
  end
end

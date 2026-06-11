defmodule CeCe.Payload.Outbound.SystemSessionStateChanged do
  @moduledoc """
  Session state changed message.

  Reports changes to the session state.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          previousState: String.t() | nil,
          newState: String.t(),
          reason: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:previousState, :newState, :reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: previousState, reason
    %__MODULE__{
      previousState: Map.get(json, "previousState"),
      newState: Map.fetch!(json, "newState"),
      reason: Map.get(json, "reason")
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemSessionStateChanged do
  @moduledoc """
  Session state changed message.

  Reports changes to the session state.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          previous_state: String.t() | nil,
          new_state: String.t(),
          reason: String.t() | nil
        }

  defstruct [:previous_state, :new_state, :reason]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      previous_state: json["previous_state"] || json["previousState"],
      new_state: json["new_state"] || json["newState"],
      reason: json["reason"]
    }
  end
end

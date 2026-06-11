defmodule CeCe.Payload.Inbound.ControlSetPermissionMode do
  @moduledoc """
  Set permission mode control request.

  Changes the permission mode for tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :setPermissionMode,
          mode: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :setPermissionMode, mode: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      mode: Map.fetch!(json, "mode")
    }
  end
end

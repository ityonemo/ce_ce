defmodule CeCe.Payload.Inbound.ControlSetPermissionMode do
  @moduledoc """
  Set permission mode control request.

  Changes the permission mode for tool execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          mode: String.t()
        }

  defstruct [:mode]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      mode: json["mode"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlSetPermissionMode do
  def encode(struct, encoder) do
    %{
      "subtype" => "set_permission_mode",
      "mode" => struct.mode
    }
    |> encoder.encode_map()
  end
end

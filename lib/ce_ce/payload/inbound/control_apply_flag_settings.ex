defmodule CeCe.Payload.Inbound.ControlApplyFlagSettings do
  @moduledoc """
  Apply flag settings control request.

  Applies configuration flag settings.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          settings: map()
        }

  defstruct [:settings]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      settings: json["settings"] || %{}
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlApplyFlagSettings do
  def encode(struct, encoder) do
    %{
      "subtype" => "apply_flag_settings",
      "settings" => struct.settings
    }
    |> encoder.encode_map()
  end
end

defmodule CeCe.Payload.Inbound.ControlInitialize do
  @moduledoc """
  Initialize control request.

  Initializes the session with configuration.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          cwd: String.t() | nil,
          system_message: String.t() | nil,
          model: String.t() | nil,
          permission_mode: String.t() | nil
        }

  defstruct [:cwd, :system_message, :model, :permission_mode]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      cwd: json["cwd"],
      system_message: json["system_message"] || json["systemMessage"],
      model: json["model"],
      permission_mode: json["permission_mode"] || json["permissionMode"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlInitialize do
  def encode(struct, encoder) do
    map =
      %{"subtype" => "initialize"}
      |> maybe_put("cwd", struct.cwd)
      |> maybe_put("system_message", struct.system_message)
      |> maybe_put("model", struct.model)
      |> maybe_put("permission_mode", struct.permission_mode)

    encoder.encode_map(map)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end

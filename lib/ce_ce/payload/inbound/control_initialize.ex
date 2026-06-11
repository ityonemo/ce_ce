defmodule CeCe.Payload.Inbound.ControlInitialize do
  @moduledoc """
  Initialize control request.

  Initializes the session with configuration.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :initialize,
          cwd: String.t() | nil,
          systemMessage: String.t() | nil,
          model: String.t() | nil,
          permissionMode: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :initialize, cwd: nil, systemMessage: nil, model: nil, permissionMode: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # All fields are optional
    %__MODULE__{
      cwd: Map.get(json, "cwd"),
      systemMessage: Map.get(json, "systemMessage"),
      model: Map.get(json, "model"),
      permissionMode: Map.get(json, "permissionMode")
    }
  end
end

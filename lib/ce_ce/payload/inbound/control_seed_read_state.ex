defmodule CeCe.Payload.Inbound.ControlSeedReadState do
  @moduledoc """
  Seed read state control request.

  Seeds the read state with file contents.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :seedReadState,
          files: map()
        }

  @derive JSON.Encoder
  defstruct subtype: :seedReadState, files: %{}

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      files: Map.fetch!(json, "files")
    }
  end
end

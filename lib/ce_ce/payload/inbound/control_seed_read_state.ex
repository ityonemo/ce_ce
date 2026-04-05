defmodule CeCe.Payload.Inbound.ControlSeedReadState do
  @moduledoc """
  Seed read state control request.

  Seeds the read state with file contents.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          files: map()
        }

  defstruct [:files]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      files: json["files"] || %{}
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlSeedReadState do
  def encode(struct, encoder) do
    %{
      "subtype" => "seed_read_state",
      "files" => struct.files
    }
    |> encoder.encode_map()
  end
end

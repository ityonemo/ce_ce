defmodule CeCe.Payload.Inbound.ControlRewindFiles do
  @moduledoc """
  Rewind files control request.

  Reverts files to a previous state.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :rewindFiles,
          files: [String.t()],
          toMessageId: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :rewindFiles, files: [], toMessageId: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: toMessageId
    %__MODULE__{
      files: Map.fetch!(json, "files"),
      toMessageId: Map.get(json, "toMessageId")
    }
  end
end

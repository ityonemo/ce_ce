defmodule CeCe.Payload.TranscriptMirror do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:filePath, :entries]

  @type t :: %__MODULE__{
          type: :transcript_mirror,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          filePath: String.t(),
          entries: [map()]
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [:session_id, :uuid, :parent_tool_use_id, type: :transcript_mirror]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      filePath: Map.fetch!(json, "filePath"),
      entries: Map.fetch!(json, "entries")
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemCompactBoundary do
  @moduledoc """
  Compact boundary message.

  Marks the boundary of a compacted conversation segment.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          boundaryId: String.t() | nil,
          messageCount: integer() | nil,
          tokenCount: integer() | nil
        }

  @derive JSON.Encoder
  defstruct [:boundaryId, :messageCount, :tokenCount]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # All fields are optional
    %__MODULE__{
      boundaryId: Map.get(json, "boundaryId"),
      messageCount: Map.get(json, "messageCount"),
      tokenCount: Map.get(json, "tokenCount")
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemCompactBoundary do
  @moduledoc """
  Compact boundary message.

  Marks the boundary of a compacted conversation segment.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          boundary_id: String.t() | nil,
          message_count: integer() | nil,
          token_count: integer() | nil
        }

  defstruct [:boundary_id, :message_count, :token_count]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      boundary_id: json["boundary_id"] || json["boundaryId"],
      message_count: json["message_count"] || json["messageCount"],
      token_count: json["token_count"] || json["tokenCount"]
    }
  end
end

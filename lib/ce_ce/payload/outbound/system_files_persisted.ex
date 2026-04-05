defmodule CeCe.Payload.Outbound.SystemFilesPersisted do
  @moduledoc """
  Files persisted message.

  Indicates files have been saved to disk.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          files: [String.t()],
          count: integer() | nil
        }

  defstruct [:files, :count]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    files = json["files"] || []

    %__MODULE__{
      files: files,
      count: json["count"] || length(files)
    }
  end
end

defmodule CeCe.Payload.Outbound.SystemHookProgress do
  @moduledoc """
  Hook progress message.

  Reports progress during hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hookName: String.t(),
          progress: float() | nil,
          message: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:hookName, :progress, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: progress, message
    %__MODULE__{
      hookName: Map.fetch!(json, "hookName"),
      progress: Map.get(json, "progress"),
      message: Map.get(json, "message")
    }
  end
end

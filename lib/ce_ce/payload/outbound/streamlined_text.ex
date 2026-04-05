defmodule CeCe.Payload.Outbound.StreamlinedText do
  @moduledoc """
  Streamlined text message.

  Simple text content in streamlined output mode.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          text: String.t()
        }

  @derive JSON.Encoder
  defstruct [:text]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      text: Map.fetch!(json, "text")
    }
  end
end

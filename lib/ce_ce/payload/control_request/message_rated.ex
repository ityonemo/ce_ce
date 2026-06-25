defmodule CeCe.Payload.ControlRequest.MessageRated do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :message_rated,
          messageUuid: String.t(),
          sentiment: String.t(),
          surface: String.t(),
          cleared: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :message_rated, messageUuid: nil, sentiment: nil, surface: nil, cleared: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      messageUuid: Map.fetch!(json, "messageUuid"),
      sentiment: Map.fetch!(json, "sentiment"),
      surface: Map.fetch!(json, "surface"),
      cleared: Map.get(json, "cleared")
    }
  end
end

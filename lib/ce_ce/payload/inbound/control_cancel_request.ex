defmodule CeCe.Payload.Inbound.ControlCancelRequest do
  @moduledoc """
  Cancel request message.

  Used to cancel an in-progress operation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :cancelRequest,
          requestId: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :cancelRequest, requestId: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      requestId: Map.fetch!(json, "requestId")
    }
  end
end

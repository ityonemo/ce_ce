defmodule CeCe.Payload.Inbound.ControlCancelAsyncMessage do
  @moduledoc """
  Cancel async message control request.

  Cancels a pending async message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :cancelAsyncMessage,
          messageId: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :cancelAsyncMessage, messageId: nil

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      messageId: Map.fetch!(json, "messageId")
    }
  end
end

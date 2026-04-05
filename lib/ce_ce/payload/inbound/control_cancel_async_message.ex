defmodule CeCe.Payload.Inbound.ControlCancelAsyncMessage do
  @moduledoc """
  Cancel async message control request.

  Cancels a pending async message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          message_id: String.t()
        }

  defstruct [:message_id]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      message_id: json["message_id"] || json["messageId"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlCancelAsyncMessage do
  def encode(struct, encoder) do
    %{
      "subtype" => "cancel_async_message",
      "message_id" => struct.message_id
    }
    |> encoder.encode_map()
  end
end

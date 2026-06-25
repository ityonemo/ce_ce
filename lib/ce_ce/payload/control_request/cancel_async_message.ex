defmodule CeCe.Payload.ControlRequest.CancelAsyncMessage do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :cancel_async_message,
          message_uuid: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :cancel_async_message, message_uuid: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{message_uuid: Map.fetch!(json, "message_uuid")}
end

defmodule CeCe.Payload.Inbound.ControlCancelRequest do
  @moduledoc """
  Cancel request message.

  Used to cancel an in-progress operation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          request_id: String.t()
        }

  defstruct [:request_id]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      request_id: json["request_id"] || json["requestId"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlCancelRequest do
  def encode(struct, encoder) do
    %{
      "type" => "control_cancel_request",
      "request_id" => struct.request_id
    }
    |> encoder.encode_map()
  end
end

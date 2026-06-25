defmodule CeCe.Payload.ControlResponse.Error do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  alias CeCe.Payload.ControlRequest

  @type t :: %__MODULE__{
          subtype: :error,
          request_id: String.t(),
          error: String.t(),
          pending_permission_requests: [ControlRequest.t()] | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :error, request_id: nil, error: nil, pending_permission_requests: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      request_id: Map.fetch!(json, "request_id"),
      error: Map.fetch!(json, "error"),
      pending_permission_requests: parse_pending(Map.get(json, "pending_permission_requests"))
    }
  end

  defp parse_pending(nil), do: nil
  defp parse_pending(requests), do: Enum.map(requests, &ControlRequest.parse/1)
end

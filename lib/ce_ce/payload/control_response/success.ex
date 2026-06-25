defmodule CeCe.Payload.ControlResponse.Success do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  alias CeCe.Payload.ControlRequest

  @type t :: %__MODULE__{
          subtype: :success,
          request_id: String.t(),
          response: json(),
          pending_permission_requests: [ControlRequest.t()] | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :success, request_id: nil, response: %{}, pending_permission_requests: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      request_id: Map.fetch!(json, "request_id"),
      response: Map.fetch!(json, "response"),
      pending_permission_requests: parse_pending(Map.get(json, "pending_permission_requests"))
    }
  end

  defp parse_pending(nil), do: nil
  defp parse_pending(requests), do: Enum.map(requests, &ControlRequest.parse/1)
end

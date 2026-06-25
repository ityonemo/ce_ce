defmodule CeCe.Payload.ControlResponse do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:response]

  alias CeCe.Payload.ControlResponse.Error
  alias CeCe.Payload.ControlResponse.Success

  @type response :: Success.t() | Error.t()

  @type t :: %__MODULE__{
          type: :control_response,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          response: response()
        }

  @derive JSON.Encoder
  defstruct @required_fields ++ [:session_id, :uuid, :parent_tool_use_id, type: :control_response]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      response: parse_response(Map.fetch!(json, "response"))
    }
  end

  defp parse_response(%{"subtype" => "success"} = json), do: Success.parse(json)
  defp parse_response(%{"subtype" => "error"} = json), do: Error.parse(json)
end

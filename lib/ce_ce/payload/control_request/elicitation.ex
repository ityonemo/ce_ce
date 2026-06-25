defmodule CeCe.Payload.ControlRequest.Elicitation do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :elicitation,
          mcp_server_name: String.t(),
          message: String.t(),
          mode: String.t() | nil,
          url: String.t() | nil,
          elicitation_id: String.t() | nil,
          requested_schema: json() | nil,
          title: String.t() | nil,
          display_name: String.t() | nil,
          description: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :elicitation,
            mcp_server_name: nil,
            message: nil,
            mode: nil,
            url: nil,
            elicitation_id: nil,
            requested_schema: nil,
            title: nil,
            display_name: nil,
            description: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      mcp_server_name: Map.fetch!(json, "mcp_server_name"),
      message: Map.fetch!(json, "message"),
      mode: Map.get(json, "mode"),
      url: Map.get(json, "url"),
      elicitation_id: Map.get(json, "elicitation_id"),
      requested_schema: Map.get(json, "requested_schema"),
      title: Map.get(json, "title"),
      display_name: Map.get(json, "display_name"),
      description: Map.get(json, "description")
    }
  end
end

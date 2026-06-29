defmodule CeCe.Payload.Assistant do
  @moduledoc false

  alias CeCe.Payload.Assistant.Message

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:message]

  @type t :: %__MODULE__{
          type: :assistant,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          timestamp: String.t() | nil,
          error: String.t() | nil,
          message: Message.t()
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [:session_id, :uuid, :parent_tool_use_id, :timestamp, :error, type: :assistant]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      timestamp: Map.get(json, "timestamp"),
      error: Map.get(json, "error"),
      message: json |> Map.fetch!("message") |> Message.parse()
    }
  end
end

defmodule CeCe.Payload.ControlRequest.CanUseTool do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :can_use_tool,
          tool_name: String.t(),
          input: json(),
          permission_suggestions: json() | nil,
          blocked_path: String.t() | nil,
          decision_reason: String.t() | nil,
          title: String.t() | nil,
          display_name: String.t() | nil,
          description: String.t() | nil,
          tool_use_id: String.t() | nil,
          agent_id: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :can_use_tool,
            tool_name: nil,
            input: %{},
            permission_suggestions: nil,
            blocked_path: nil,
            decision_reason: nil,
            title: nil,
            display_name: nil,
            description: nil,
            tool_use_id: nil,
            agent_id: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      tool_name: Map.fetch!(json, "tool_name"),
      input: Map.fetch!(json, "input"),
      permission_suggestions: Map.get(json, "permission_suggestions"),
      blocked_path: Map.get(json, "blocked_path"),
      decision_reason: Map.get(json, "decision_reason"),
      title: Map.get(json, "title"),
      display_name: Map.get(json, "display_name"),
      description: Map.get(json, "description"),
      tool_use_id: Map.get(json, "tool_use_id"),
      agent_id: Map.get(json, "agent_id")
    }
  end
end

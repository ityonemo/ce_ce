defmodule CeCe.Payload.Inbound.User do
  @moduledoc """
  User payload containing tool execution results.
  """

  use CeCe.AccessFunctions

  @type tool_use_result :: %{
          stdout: String.t() | nil,
          stderr: String.t() | nil,
          interrupted: boolean(),
          isImage: boolean()
        }

  @type t :: %__MODULE__{
          type: :user,
          content: [map()],
          toolUseResult: tool_use_result() | nil,
          isReplay: boolean(),
          priority: integer() | nil,
          timestamp: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct type: :user,
            content: [],
            toolUseResult: nil,
            isReplay: false,
            priority: nil,
            timestamp: nil

  def parse(json) do
    message = Map.fetch!(json, "message")

    # Optional: toolUseResult, priority, timestamp; isReplay defaults to false
    %__MODULE__{
      content: Map.fetch!(message, "content"),
      toolUseResult: parse_tool_use_result(Map.get(json, "toolUseResult")),
      isReplay: Map.get(json, "isReplay", false),
      priority: Map.get(json, "priority"),
      timestamp: Map.get(json, "timestamp")
    }
  end

  defp parse_tool_use_result(nil), do: nil

  defp parse_tool_use_result(result) when is_map(result) do
    # Optional: stdout, stderr; interrupted and isImage default to false
    %{
      stdout: Map.get(result, "stdout"),
      stderr: Map.get(result, "stderr"),
      interrupted: Map.get(result, "interrupted", false),
      isImage: Map.get(result, "isImage", false)
    }
  end
end

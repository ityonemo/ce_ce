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

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.User do
  def encode(user, encoder) do
    tool_use_result =
      if user.toolUseResult do
        %{
          "stdout" => user.toolUseResult.stdout,
          "stderr" => user.toolUseResult.stderr,
          "interrupted" => user.toolUseResult.interrupted,
          "isImage" => user.toolUseResult.isImage
        }
      else
        nil
      end

    %{
      "message" => %{
        "role" => "user",
        "content" => user.content
      },
      "toolUseResult" => tool_use_result,
      "isReplay" => user.isReplay,
      "priority" => user.priority,
      "timestamp" => user.timestamp
    }
    |> JSON.Encoder.Map.encode(encoder)
  end
end

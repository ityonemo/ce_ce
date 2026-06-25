defmodule CeCe.Payload.Assistant.Message do
  @moduledoc """
  Nested Anthropic assistant message payload.
  """

  use CeCe.Payload

  @type json :: CeCe.Message.json()

  @required_fields [:content]

  alias CeCe.Payload.Common.TextContent
  alias CeCe.Payload.Assistant.ToolUseContent
  alias CeCe.Payload.Assistant.ServerToolUseContent
  alias CeCe.Payload.Assistant.McpToolUseContent
  alias CeCe.Payload.Assistant.ThinkingContent
  alias CeCe.Payload.Common.ImageContent
  alias CeCe.Payload.Common.UnknownContent

  @type content ::
          TextContent.t()
          | ToolUseContent.t()
          | ServerToolUseContent.t()
          | McpToolUseContent.t()
          | ThinkingContent.t()
          | ImageContent.t()
          | UnknownContent.t()

  @type t :: %__MODULE__{
          role: :assistant,
          content: [content()],
          id: String.t() | nil,
          model: String.t() | nil,
          stop_reason: String.t() | nil,
          stop_sequence: String.t() | nil,
          usage: %{optional(String.t()) => json()} | nil
        }

  @derive JSON.Encoder
  defstruct @required_fields ++
              [
                :id,
                :model,
                :stop_reason,
                :stop_sequence,
                :usage,
                role: :assistant
              ]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      id: Map.get(json, "id"),
      model: Map.get(json, "model"),
      content: Map.fetch!(json, "content") |> Enum.map(&parse_content_block/1),
      stop_reason: Map.get(json, "stop_reason"),
      stop_sequence: Map.get(json, "stop_sequence"),
      usage: Map.get(json, "usage")
    }
  end

  defp parse_content_block(%{"type" => "text"} = json), do: TextContent.parse(json)
  defp parse_content_block(%{"type" => "tool_use"} = json), do: ToolUseContent.parse(json)

  defp parse_content_block(%{"type" => "server_tool_use"} = json),
    do: ServerToolUseContent.parse(json)

  defp parse_content_block(%{"type" => "mcp_tool_use"} = json),
    do: McpToolUseContent.parse(json)

  defp parse_content_block(%{"type" => "thinking"} = json), do: ThinkingContent.parse(json)

  defp parse_content_block(%{"type" => "redacted_thinking"} = json),
    do: ThinkingContent.parse(json)

  defp parse_content_block(%{"type" => "image"} = json), do: ImageContent.parse(json)
  defp parse_content_block(%{"type" => _} = json), do: UnknownContent.parse(json)
end

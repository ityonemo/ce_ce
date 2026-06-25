defmodule CeCe.Payload.User.ToolResultContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  alias CeCe.Payload.User.AudioContent
  alias CeCe.Payload.Common.ImageContent
  alias CeCe.Payload.User.ResourceContent
  alias CeCe.Payload.User.ResourceLinkContent
  alias CeCe.Payload.Common.TextContent
  alias CeCe.Payload.Common.UnknownContent

  @type content ::
          TextContent.t()
          | ImageContent.t()
          | AudioContent.t()
          | ResourceContent.t()
          | ResourceLinkContent.t()
          | UnknownContent.t()

  @type t :: %__MODULE__{
          type: :tool_result,
          tool_use_id: String.t() | nil,
          toolUseId: String.t() | nil,
          content: String.t() | [content()] | nil,
          structuredContent: %{optional(String.t()) => json()} | nil,
          is_error: boolean() | nil,
          isError: boolean() | nil,
          _meta: %{optional(String.t()) => json()} | nil,
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :tool_result,
            tool_use_id: nil,
            toolUseId: nil,
            content: nil,
            structuredContent: nil,
            is_error: nil,
            isError: nil,
            _meta: nil,
            extra: %{}

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      tool_use_id: Map.get(json, "tool_use_id"),
      toolUseId: Map.get(json, "toolUseId"),
      content: parse_content(Map.get(json, "content")),
      structuredContent: Map.get(json, "structuredContent"),
      is_error: Map.get(json, "is_error"),
      isError: Map.get(json, "isError"),
      _meta: Map.get(json, "_meta"),
      extra:
        Map.drop(json, [
          "type",
          "tool_use_id",
          "toolUseId",
          "content",
          "structuredContent",
          "is_error",
          "isError",
          "_meta"
        ])
    }
  end

  defp parse_content(nil), do: nil
  defp parse_content(content) when is_binary(content), do: content
  defp parse_content(content) when is_list(content), do: Enum.map(content, &parse_content_block/1)

  defp parse_content_block(%{"type" => "text"} = json), do: TextContent.parse(json)
  defp parse_content_block(%{"type" => "image"} = json), do: ImageContent.parse(json)
  defp parse_content_block(%{"type" => "audio"} = json), do: AudioContent.parse(json)
  defp parse_content_block(%{"type" => "resource"} = json), do: ResourceContent.parse(json)

  defp parse_content_block(%{"type" => "resource_link"} = json),
    do: ResourceLinkContent.parse(json)

  defp parse_content_block(%{"type" => _} = json), do: UnknownContent.parse(json)

  defimpl JSON.Encoder do
    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

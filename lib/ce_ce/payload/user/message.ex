defmodule CeCe.Payload.User.Message do
  @moduledoc """
  Nested Anthropic user message payload.
  """

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:content]

  alias CeCe.Payload.Common.TextContent
  alias CeCe.Payload.User.ToolResultContent
  alias CeCe.Payload.Common.ImageContent
  alias CeCe.Payload.User.AudioContent
  alias CeCe.Payload.User.ResourceContent
  alias CeCe.Payload.User.ResourceLinkContent
  alias CeCe.Payload.Common.UnknownContent

  @content_modules %{
    "text" => TextContent,
    "tool_result" => ToolResultContent,
    "image" => ImageContent,
    "audio" => AudioContent,
    "resource" => ResourceContent,
    "resource_link" => ResourceLinkContent
  }

  @type content ::
          TextContent.t()
          | ToolResultContent.t()
          | ImageContent.t()
          | AudioContent.t()
          | ResourceContent.t()
          | ResourceLinkContent.t()
          | UnknownContent.t()

  @type t :: %__MODULE__{
          role: :user,
          content: String.t() | [content()]
        }

  @derive JSON.Encoder
  defstruct @required_fields ++ [role: :user]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      content: parse_content(Map.fetch!(json, "content"))
    }
  end

  defp parse_content(content) when is_binary(content), do: content
  defp parse_content(content) when is_list(content), do: Enum.map(content, &parse_content_block/1)

  defp parse_content_block(%{"type" => type} = json) do
    Map.get(@content_modules, type, UnknownContent).parse(json)
  end
end

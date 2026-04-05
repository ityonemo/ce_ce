defmodule CeCe.Payload.Outbound.Assistant do
  @moduledoc """
  Assistant payload containing Claude's response.

  Content blocks can be:
  - `CeCe.Content.Text` - Text response
  - `CeCe.Content.ToolUse` - Tool invocation
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          model: String.t(),
          message_id: String.t(),
          content: [struct()],
          stop_reason: String.t() | nil,
          usage: map() | nil
        }

  defstruct [
    :model,
    :message_id,
    :content,
    :stop_reason,
    :usage
  ]

  def parse(json) do
    message = json["message"] || %{}

    %__MODULE__{
      model: message["model"],
      message_id: message["id"],
      content: parse_content(message["content"]),
      stop_reason: message["stop_reason"],
      usage: parse_usage(message["usage"])
    }
  end

  defp parse_content(nil), do: []

  defp parse_content(content_list) do
    Enum.map(content_list, &parse_content_block/1)
  end

  defp parse_content_block(%{"type" => "text"} = block) do
    CeCe.Content.Text.parse(block)
  end

  defp parse_content_block(%{"type" => "tool_use"} = block) do
    CeCe.Content.ToolUse.parse(block)
  end

  defp parse_content_block(block) do
    # Unknown content type, return as-is
    block
  end

  defp parse_usage(nil), do: nil

  defp parse_usage(usage) do
    %{
      input_tokens: usage["input_tokens"],
      output_tokens: usage["output_tokens"],
      cache_creation_input_tokens: usage["cache_creation_input_tokens"],
      cache_read_input_tokens: usage["cache_read_input_tokens"]
    }
  end
end

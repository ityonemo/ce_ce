defmodule CeCe.Payload.Outbound.Assistant do
  @moduledoc """
  Assistant payload containing Claude's response.

  Content blocks can be:
  - `CeCe.Content.Text` - Text response
  - `CeCe.Content.ToolUse` - Tool invocation
  """

  alias CeCe.Content.Usage

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          model: String.t(),
          messageId: String.t(),
          content: [struct()],
          stopReason: String.t() | nil,
          usage: Usage.t() | nil
        }

  @derive JSON.Encoder
  defstruct [
    :model,
    :messageId,
    :content,
    :stopReason,
    :usage
  ]

  @content_types %{
    "text" => CeCe.Content.Text,
    "toolUse" => CeCe.Content.ToolUse
  }

  def parse(json) do
    message = Map.fetch!(json, "message")

    %__MODULE__{
      model: Map.fetch!(message, "model"),
      messageId: Map.fetch!(message, "id"),
      content: message |> Map.fetch!("content") |> Enum.map(&parse_content_block!/1),
      stopReason: Map.get(message, "stopReason"),
      usage: Usage.parse(Map.get(message, "usage"))
    }
  end

  defp parse_content_block!(block) do
    type = Map.fetch!(block, "type")
    Map.fetch!(@content_types, type).parse(block)
  end
end

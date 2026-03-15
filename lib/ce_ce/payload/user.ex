defmodule CeCe.Payload.User do
  @moduledoc """
  User payload containing tool execution results.
  """

  @type tool_use_result :: %{
          stdout: String.t(),
          stderr: String.t(),
          interrupted: boolean(),
          is_image: boolean()
        }

  @type t :: %__MODULE__{
          content: [map()],
          tool_use_result: tool_use_result() | nil
        }

  defstruct [
    :content,
    :tool_use_result
  ]

  def parse(json) do
    message = json["message"] || %{}

    %__MODULE__{
      content: message["content"] || [],
      tool_use_result: parse_tool_use_result(json["tool_use_result"])
    }
  end

  defp parse_tool_use_result(nil), do: nil

  defp parse_tool_use_result(result) do
    %{
      stdout: result["stdout"],
      stderr: result["stderr"],
      interrupted: result["interrupted"] || false,
      is_image: result["isImage"] || false
    }
  end
end

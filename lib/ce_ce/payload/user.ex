defmodule CeCe.Payload.User do
  @moduledoc """
  User payload containing tool execution results.
  """

  @behaviour Access

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

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(_, _, _), do: raise("CeCe.Payload.User is read-only")

  @impl Access
  def pop(_, _), do: raise("CeCe.Payload.User is read-only")

  def parse(json) do
    message = json["message"] || %{}

    %__MODULE__{
      content: message["content"] || [],
      tool_use_result: parse_tool_use_result(json["tool_use_result"])
    }
  end

  defp parse_tool_use_result(nil), do: nil

  defp parse_tool_use_result(result) when is_map(result) do
    %{
      stdout: Map.get(result, "stdout") || Map.get(result, :stdout),
      stderr: Map.get(result, "stderr") || Map.get(result, :stderr),
      interrupted: Map.get(result, "interrupted") || Map.get(result, :interrupted) || false,
      is_image: Map.get(result, "isImage") || Map.get(result, :is_image) || false
    }
  end

  defp parse_tool_use_result(result) when is_list(result) do
    %{
      stdout: Keyword.get(result, :stdout),
      stderr: Keyword.get(result, :stderr),
      interrupted: Keyword.get(result, :interrupted, false),
      is_image: Keyword.get(result, :is_image, false)
    }
  end

  # Handle string error messages
  defp parse_tool_use_result(result) when is_binary(result) do
    %{
      stdout: nil,
      stderr: result,
      interrupted: false,
      is_image: false
    }
  end
end

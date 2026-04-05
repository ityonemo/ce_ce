defmodule CeCe.Content.ToolUse do
  @moduledoc """
  Tool use content block from an assistant message.

  Represents Claude's request to invoke a tool.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          input: map()
        }

  defstruct [:id, :name, :input]

  def parse(json) do
    %__MODULE__{
      id: json["id"],
      name: json["name"],
      input: json["input"] || %{}
    }
  end
end

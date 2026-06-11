defmodule CeCe.Content.ToolUse do
  @moduledoc """
  Tool use content block from an assistant message.

  Represents Claude's request to invoke a tool.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: :toolUse,
          id: String.t(),
          name: String.t(),
          input: map()
        }

  @derive JSON.Encoder
  defstruct type: :toolUse, id: nil, name: nil, input: %{}

  def parse(json) do
    %__MODULE__{
      id: Map.fetch!(json, "id"),
      name: Map.fetch!(json, "name"),
      input: Map.fetch!(json, "input")
    }
  end
end

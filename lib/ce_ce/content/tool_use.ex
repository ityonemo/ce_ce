defmodule CeCe.Content.ToolUse do
  @moduledoc """
  Tool use content block from an assistant message.

  Represents Claude's request to invoke a tool.
  """

  @behaviour Access

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          input: map()
        }

  defstruct [:id, :name, :input]

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(_, _, _), do: raise("CeCe.Content.ToolUse is read-only")

  @impl Access
  def pop(_, _), do: raise("CeCe.Content.ToolUse is read-only")

  def parse(json) do
    %__MODULE__{
      id: json["id"],
      name: json["name"],
      input: json["input"] || %{}
    }
  end
end

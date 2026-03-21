defmodule CeCe.Content.Text do
  @moduledoc """
  Text content block from an assistant message.
  """

  @behaviour Access

  @type t :: %__MODULE__{
          text: String.t()
        }

  defstruct [:text]

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(_, _, _), do: raise("CeCe.Content.Text is read-only")

  @impl Access
  def pop(_, _), do: raise("CeCe.Content.Text is read-only")

  def parse(json) do
    %__MODULE__{
      text: json["text"]
    }
  end
end

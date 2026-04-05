defmodule CeCe.Content.Text do
  @moduledoc """
  Text content block from an assistant message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          text: String.t()
        }

  @derive JSON.Encoder
  defstruct [:text]

  def parse(json) do
    %__MODULE__{
      text: Map.fetch!(json, "text")
    }
  end
end

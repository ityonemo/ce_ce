defmodule CeCe.Content.Text do
  @moduledoc """
  Text content block from an assistant message.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: :text,
          text: String.t()
        }

  @derive JSON.Encoder
  defstruct type: :text, text: nil

  def parse(json) do
    %__MODULE__{
      text: Map.fetch!(json, "text")
    }
  end
end

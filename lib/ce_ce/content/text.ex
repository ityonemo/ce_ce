defmodule CeCe.Content.Text do
  @moduledoc """
  Text content block from an assistant message.
  """

  @type t :: %__MODULE__{
          text: String.t()
        }

  defstruct [:text]

  def parse(json) do
    %__MODULE__{
      text: json["text"]
    }
  end
end

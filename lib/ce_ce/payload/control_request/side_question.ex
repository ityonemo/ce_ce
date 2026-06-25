defmodule CeCe.Payload.ControlRequest.SideQuestion do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :side_question,
          question: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :side_question, question: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{question: Map.fetch!(json, "question")}
end

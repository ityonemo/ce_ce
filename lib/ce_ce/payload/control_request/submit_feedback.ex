defmodule CeCe.Payload.ControlRequest.SubmitFeedback do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :submit_feedback,
          description: String.t(),
          surface: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :submit_feedback, description: nil, surface: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      description: Map.fetch!(json, "description"),
      surface: Map.get(json, "surface")
    }
  end
end

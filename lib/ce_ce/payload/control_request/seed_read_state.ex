defmodule CeCe.Payload.ControlRequest.SeedReadState do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :seed_read_state,
          path: String.t(),
          mtime: number()
        }

  @derive JSON.Encoder
  defstruct subtype: :seed_read_state, path: nil, mtime: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      path: Map.fetch!(json, "path"),
      mtime: Map.fetch!(json, "mtime")
    }
  end
end

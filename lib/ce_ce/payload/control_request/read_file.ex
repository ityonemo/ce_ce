defmodule CeCe.Payload.ControlRequest.ReadFile do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :read_file,
          path: String.t(),
          max_bytes: number() | nil,
          encoding: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :read_file, path: nil, max_bytes: nil, encoding: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      path: Map.fetch!(json, "path"),
      max_bytes: Map.get(json, "max_bytes"),
      encoding: Map.get(json, "encoding")
    }
  end
end

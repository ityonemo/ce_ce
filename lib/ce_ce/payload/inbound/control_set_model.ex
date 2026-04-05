defmodule CeCe.Payload.Inbound.ControlSetModel do
  @moduledoc """
  Set model control request.

  Changes the model used for generation.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          model: String.t()
        }

  defstruct [:model]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      model: json["model"]
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.ControlSetModel do
  def encode(struct, encoder) do
    %{
      "subtype" => "set_model",
      "model" => struct.model
    }
    |> encoder.encode_map()
  end
end

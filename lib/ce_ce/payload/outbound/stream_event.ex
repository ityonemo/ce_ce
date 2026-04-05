defmodule CeCe.Payload.Outbound.StreamEvent do
  @moduledoc """
  Raw stream event passthrough.

  Contains raw event data from the underlying API.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          eventType: String.t(),
          data: map()
        }

  @derive JSON.Encoder
  defstruct [:eventType, :data]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      eventType: Map.fetch!(json, "eventType"),
      data: Map.fetch!(json, "data")
    }
  end
end

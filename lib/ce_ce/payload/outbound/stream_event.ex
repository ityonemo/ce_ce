defmodule CeCe.Payload.Outbound.StreamEvent do
  @moduledoc """
  Raw stream event passthrough.

  Contains raw event data from the underlying API.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          event_type: String.t(),
          data: map()
        }

  defstruct [:event_type, :data]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      event_type: json["event_type"] || json["eventType"],
      data: json["data"] || %{}
    }
  end
end

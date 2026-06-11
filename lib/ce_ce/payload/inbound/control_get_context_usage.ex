defmodule CeCe.Payload.Inbound.ControlGetContextUsage do
  @moduledoc """
  Get context usage control request.

  Requests information about context window usage.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :getContextUsage
        }

  @derive JSON.Encoder
  defstruct subtype: :getContextUsage

  @doc "Parse decoded JSON map into struct."
  def parse(_json) do
    %__MODULE__{}
  end
end

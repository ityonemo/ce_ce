defmodule CeCe.Payload.Inbound.UpdateEnvironmentVariables do
  @moduledoc """
  Update environment variables message (inbound only).

  Sent to update environment variables for the session.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: :updateEnvironmentVariables,
          variables: map()
        }

  @derive JSON.Encoder
  defstruct type: :updateEnvironmentVariables, variables: %{}

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      variables: Map.fetch!(json, "variables")
    }
  end
end

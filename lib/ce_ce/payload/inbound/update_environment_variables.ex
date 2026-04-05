defmodule CeCe.Payload.Inbound.UpdateEnvironmentVariables do
  @moduledoc """
  Update environment variables message (inbound only).

  Sent to update environment variables for the session.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          variables: map()
        }

  defstruct [:variables]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      variables: json["variables"] || %{}
    }
  end
end

defimpl JSON.Encoder, for: CeCe.Payload.Inbound.UpdateEnvironmentVariables do
  def encode(struct, encoder) do
    %{
      "type" => "update_environment_variables",
      "variables" => struct.variables
    }
    |> encoder.encode_map()
  end
end

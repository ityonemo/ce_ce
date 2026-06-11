defmodule CeCe.Payload.Outbound.SystemLocalCommandOutput do
  @moduledoc """
  Local command output message.

  Output from a locally executed command.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          command: String.t() | nil,
          output: String.t() | nil,
          exitCode: integer() | nil,
          isError: boolean()
        }

  @derive JSON.Encoder
  defstruct [:command, :output, :exitCode, :isError]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    # Optional: command, output, exitCode; isError defaults to false
    %__MODULE__{
      command: Map.get(json, "command"),
      output: Map.get(json, "output"),
      exitCode: Map.get(json, "exitCode"),
      isError: Map.get(json, "isError", false)
    }
  end
end

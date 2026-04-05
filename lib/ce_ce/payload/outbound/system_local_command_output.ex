defmodule CeCe.Payload.Outbound.SystemLocalCommandOutput do
  @moduledoc """
  Local command output message.

  Output from a locally executed command.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          command: String.t() | nil,
          output: String.t() | nil,
          exit_code: integer() | nil,
          is_error: boolean()
        }

  defstruct [:command, :output, :exit_code, :is_error]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      command: json["command"],
      output: json["output"],
      exit_code: json["exit_code"] || json["exitCode"],
      is_error: json["is_error"] || json["isError"] || false
    }
  end
end

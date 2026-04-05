defmodule CeCe.Payload.Outbound.SystemHookProgress do
  @moduledoc """
  Hook progress message.

  Reports progress during hook execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hook_name: String.t(),
          progress: float() | nil,
          message: String.t() | nil
        }

  defstruct [:hook_name, :progress, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      hook_name: json["hook_name"] || json["hookName"],
      progress: json["progress"],
      message: json["message"]
    }
  end
end

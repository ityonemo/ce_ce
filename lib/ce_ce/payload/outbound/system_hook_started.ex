defmodule CeCe.Payload.Outbound.SystemHookStarted do
  @moduledoc """
  Hook started message.

  Indicates a hook has begun execution.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          hook_name: String.t(),
          hook_type: String.t() | nil,
          context: map()
        }

  defstruct [:hook_name, :hook_type, :context]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      hook_name: json["hook_name"] || json["hookName"],
      hook_type: json["hook_type"] || json["hookType"],
      context: json["context"] || %{}
    }
  end
end

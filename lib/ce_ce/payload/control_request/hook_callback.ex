defmodule CeCe.Payload.ControlRequest.HookCallback do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :hook_callback,
          callback_id: String.t(),
          input: json(),
          tool_use_id: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :hook_callback, callback_id: nil, input: %{}, tool_use_id: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      callback_id: Map.fetch!(json, "callback_id"),
      input: Map.fetch!(json, "input"),
      tool_use_id: Map.get(json, "tool_use_id")
    }
  end
end

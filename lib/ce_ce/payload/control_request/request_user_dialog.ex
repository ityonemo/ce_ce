defmodule CeCe.Payload.ControlRequest.RequestUserDialog do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :request_user_dialog,
          dialog_kind: String.t(),
          payload: json(),
          tool_use_id: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :request_user_dialog, dialog_kind: nil, payload: %{}, tool_use_id: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      dialog_kind: Map.fetch!(json, "dialog_kind"),
      payload: Map.fetch!(json, "payload"),
      tool_use_id: Map.get(json, "tool_use_id")
    }
  end
end

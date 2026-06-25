defmodule CeCe.Payload.ControlRequest.RemoteControl do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :remote_control,
          enabled: boolean(),
          name: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :remote_control, enabled: false, name: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      enabled: Map.fetch!(json, "enabled"),
      name: Map.get(json, "name")
    }
  end
end

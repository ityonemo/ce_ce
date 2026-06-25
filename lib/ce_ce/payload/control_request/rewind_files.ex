defmodule CeCe.Payload.ControlRequest.RewindFiles do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :rewind_files,
          user_message_id: String.t(),
          dry_run: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :rewind_files, user_message_id: nil, dry_run: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      user_message_id: Map.fetch!(json, "user_message_id"),
      dry_run: Map.get(json, "dry_run")
    }
  end
end

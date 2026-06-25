defmodule CeCe.Payload.System do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:subtype]

  @type t :: %__MODULE__{
          type: :system,
          subtype: String.t(),
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          error: String.t() | nil,
          key: map() | nil,
          data: %{optional(String.t()) => json()}
        }

  defstruct @required_fields ++ [:session_id, :uuid, :error, :key, data: %{}, type: :system]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      subtype: Map.fetch!(json, "subtype"),
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      error: Map.get(json, "error"),
      key: Map.get(json, "key"),
      data: Map.drop(json, ["type", "subtype", "session_id", "uuid", "error", "key"])
    }
  end

  defimpl JSON.Encoder do
    def encode(system, encoder) do
      system
      |> Map.from_struct()
      |> Map.delete(:data)
      |> Map.merge(system.data)
      |> JSON.Encoder.Map.encode(encoder)
    end
  end
end

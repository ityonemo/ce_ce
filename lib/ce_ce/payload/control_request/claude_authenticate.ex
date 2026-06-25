defmodule CeCe.Payload.ControlRequest.ClaudeAuthenticate do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :claude_authenticate,
          loginWithClaudeAi: boolean()
        }

  @derive JSON.Encoder
  defstruct subtype: :claude_authenticate, loginWithClaudeAi: false

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json), do: %__MODULE__{loginWithClaudeAi: Map.fetch!(json, "loginWithClaudeAi")}
end

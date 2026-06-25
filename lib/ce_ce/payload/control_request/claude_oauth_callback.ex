defmodule CeCe.Payload.ControlRequest.ClaudeOAuthCallback do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype: :claude_oauth_callback,
          authorizationCode: String.t(),
          state: String.t()
        }

  @derive JSON.Encoder
  defstruct subtype: :claude_oauth_callback, authorizationCode: nil, state: nil

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(json) do
    %__MODULE__{
      authorizationCode: Map.fetch!(json, "authorizationCode"),
      state: Map.fetch!(json, "state")
    }
  end
end

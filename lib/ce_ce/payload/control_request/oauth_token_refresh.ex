defmodule CeCe.Payload.ControlRequest.OauthTokenRefresh do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{subtype: :oauth_token_refresh}

  @derive JSON.Encoder
  defstruct subtype: :oauth_token_refresh

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(_json), do: %__MODULE__{}
end

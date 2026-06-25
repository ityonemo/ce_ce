defmodule CeCe.Payload.ControlRequest.HostAuthTokenRefresh do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{subtype: :host_auth_token_refresh}

  @derive JSON.Encoder
  defstruct subtype: :host_auth_token_refresh

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(_json), do: %__MODULE__{}
end

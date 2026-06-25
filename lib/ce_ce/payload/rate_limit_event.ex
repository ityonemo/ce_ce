defmodule CeCe.Payload.RateLimitEvent do
  @moduledoc """
  A `rate_limit_event` message emitted by the Claude Code CLI.

  This type is not part of the documented SDK stream schema (the VS Code
  extension's transport drops it); only the webview consumes it. Modeled
  here from the live 2.1.193 payload and the extension's webview code:
  the envelope wraps a single snake_case key, `rate_limit_info`.
  """

  alias CeCe.Payload.RateLimitEvent.RateLimitInfo

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :rate_limit_event,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          rate_limit_info: RateLimitInfo.t()
        }

  @derive JSON.Encoder
  defstruct [
    :session_id,
    :uuid,
    :parent_tool_use_id,
    :rate_limit_info,
    type: :rate_limit_event
  ]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      rate_limit_info: json |> Map.fetch!("rate_limit_info") |> RateLimitInfo.parse()
    }
  end
end

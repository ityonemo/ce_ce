defmodule CeCe.Payload.ControlRequest.SimpleControl do
  @moduledoc false

  use CeCe.Payload

  @type t :: %__MODULE__{
          subtype:
            :interrupt
            | :get_settings
            | :claude_oauth_wait_for_completion
            | :mcp_status
            | :get_context_usage
            | :reload_plugins
            | :reload_skills
            | :channel_enable
        }

  @derive JSON.Encoder
  defstruct subtype: nil

  @subtypes %{
    "interrupt" => :interrupt,
    "get_settings" => :get_settings,
    "claude_oauth_wait_for_completion" => :claude_oauth_wait_for_completion,
    "mcp_status" => :mcp_status,
    "get_context_usage" => :get_context_usage,
    "reload_plugins" => :reload_plugins,
    "reload_skills" => :reload_skills,
    "channel_enable" => :channel_enable
  }

  @spec parse(%{String.t() => CeCe.Payload.json()}) :: t()
  def parse(%{"subtype" => subtype}) do
    %__MODULE__{subtype: Map.fetch!(@subtypes, subtype)}
  end
end

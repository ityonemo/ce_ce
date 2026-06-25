defmodule CeCe.Payload.Outbound.SystemInit do
  @moduledoc """
  System init payload, sent at startup with session configuration.
  """

  alias CeCe.Content.McpServerStatus
  alias CeCe.Content.SlashCommand
  alias CeCe.Content.AgentInfo
  alias CeCe.Content.PluginInfo

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :init,
          cwd: String.t(),
          tools: [String.t()],
          mcp_servers: [McpServerStatus.t()],
          model: String.t(),
          permissionMode: String.t(),
          slash_commands: [SlashCommand.t()],
          apiKeySource: String.t(),
          claude_code_version: String.t(),
          output_style: String.t(),
          agents: [AgentInfo.t()],
          skills: [String.t()],
          plugins: [PluginInfo.t()]
        }

  @derive JSON.Encoder
  defstruct subtype: :init,
            cwd: nil,
            tools: [],
            mcp_servers: [],
            model: nil,
            permissionMode: nil,
            slash_commands: [],
            apiKeySource: nil,
            claude_code_version: nil,
            output_style: nil,
            agents: [],
            skills: [],
            plugins: []

  @doc "Parse decoded JSON map into struct."
  def parse(json) do
    %__MODULE__{
      cwd: Map.fetch!(json, "cwd"),
      tools: Map.fetch!(json, "tools"),
      mcp_servers: json |> Map.fetch!("mcp_servers") |> Enum.map(&McpServerStatus.parse/1),
      model: Map.fetch!(json, "model"),
      permissionMode: Map.fetch!(json, "permissionMode"),
      slash_commands: json |> Map.fetch!("slash_commands") |> Enum.map(&SlashCommand.parse/1),
      apiKeySource: Map.fetch!(json, "apiKeySource"),
      claude_code_version: Map.fetch!(json, "claude_code_version"),
      output_style: Map.fetch!(json, "output_style"),
      agents: json |> Map.fetch!("agents") |> Enum.map(&AgentInfo.parse/1),
      skills: Map.fetch!(json, "skills"),
      plugins: json |> Map.fetch!("plugins") |> Enum.map(&PluginInfo.parse/1)
    }
  end
end

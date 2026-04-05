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
          cwd: String.t(),
          tools: [String.t()],
          mcp_servers: [McpServerStatus.t()],
          model: String.t(),
          permission_mode: String.t(),
          slash_commands: [SlashCommand.t()],
          api_key_source: String.t(),
          claude_code_version: String.t(),
          output_style: String.t(),
          agents: [AgentInfo.t()],
          skills: [String.t()],
          plugins: [PluginInfo.t()]
        }

  defstruct [
    :cwd,
    :tools,
    :mcp_servers,
    :model,
    :permission_mode,
    :slash_commands,
    :api_key_source,
    :claude_code_version,
    :output_style,
    :agents,
    :skills,
    :plugins
  ]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      cwd: json["cwd"],
      tools: json["tools"] || [],
      mcp_servers: McpServerStatus.parse_list(json["mcp_servers"]),
      model: json["model"],
      permission_mode: json["permissionMode"],
      slash_commands: SlashCommand.parse_list(json["slash_commands"]),
      api_key_source: json["apiKeySource"],
      claude_code_version: json["claude_code_version"],
      output_style: json["output_style"],
      agents: AgentInfo.parse_list(json["agents"]),
      skills: json["skills"] || [],
      plugins: PluginInfo.parse_list(json["plugins"])
    }
  end
end

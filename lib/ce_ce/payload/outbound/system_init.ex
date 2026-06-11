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
          mcpServers: [McpServerStatus.t()],
          model: String.t(),
          permissionMode: String.t(),
          slashCommands: [SlashCommand.t()],
          apiKeySource: String.t(),
          claudeCodeVersion: String.t(),
          outputStyle: String.t(),
          agents: [AgentInfo.t()],
          skills: [String.t()],
          plugins: [PluginInfo.t()]
        }

  @derive JSON.Encoder
  defstruct subtype: :init,
            cwd: nil,
            tools: [],
            mcpServers: [],
            model: nil,
            permissionMode: nil,
            slashCommands: [],
            apiKeySource: nil,
            claudeCodeVersion: nil,
            outputStyle: nil,
            agents: [],
            skills: [],
            plugins: []

  @doc "Parse decoded JSON map into struct."
  def parse(json) do
    %__MODULE__{
      cwd: Map.fetch!(json, "cwd"),
      tools: Map.fetch!(json, "tools"),
      mcpServers: json |> Map.fetch!("mcpServers") |> Enum.map(&McpServerStatus.parse/1),
      model: Map.fetch!(json, "model"),
      permissionMode: Map.fetch!(json, "permissionMode"),
      slashCommands: json |> Map.fetch!("slashCommands") |> Enum.map(&SlashCommand.parse/1),
      apiKeySource: Map.fetch!(json, "apiKeySource"),
      claudeCodeVersion: Map.fetch!(json, "claudeCodeVersion"),
      outputStyle: Map.fetch!(json, "outputStyle"),
      agents: json |> Map.fetch!("agents") |> Enum.map(&AgentInfo.parse/1),
      skills: Map.fetch!(json, "skills"),
      plugins: json |> Map.fetch!("plugins") |> Enum.map(&PluginInfo.parse/1)
    }
  end
end

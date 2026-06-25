defmodule CeCe.Payload.ControlRequest.Initialize do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          subtype: :initialize,
          hooks: json() | nil,
          sdkMcpServers: [String.t()] | nil,
          jsonSchema: json() | nil,
          systemPrompt: [String.t()] | nil,
          appendSystemPrompt: String.t() | nil,
          planModeInstructions: String.t() | nil,
          appendSubagentSystemPrompt: String.t() | nil,
          toolAliases: json() | nil,
          excludeDynamicSections: boolean() | nil,
          agents: json() | nil,
          title: String.t() | nil,
          skills: [String.t()] | nil,
          webSearchIsolationExemptMcpServers: [String.t()] | nil,
          promptSuggestions: json() | nil,
          agentProgressSummaries: json() | nil,
          forwardSubagentText: boolean() | nil
        }

  @derive JSON.Encoder
  defstruct subtype: :initialize,
            hooks: nil,
            sdkMcpServers: nil,
            jsonSchema: nil,
            systemPrompt: nil,
            appendSystemPrompt: nil,
            planModeInstructions: nil,
            appendSubagentSystemPrompt: nil,
            toolAliases: nil,
            excludeDynamicSections: nil,
            agents: nil,
            title: nil,
            skills: nil,
            webSearchIsolationExemptMcpServers: nil,
            promptSuggestions: nil,
            agentProgressSummaries: nil,
            forwardSubagentText: nil

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      hooks: Map.get(json, "hooks"),
      sdkMcpServers: Map.get(json, "sdkMcpServers"),
      jsonSchema: Map.get(json, "jsonSchema"),
      systemPrompt: Map.get(json, "systemPrompt"),
      appendSystemPrompt: Map.get(json, "appendSystemPrompt"),
      planModeInstructions: Map.get(json, "planModeInstructions"),
      appendSubagentSystemPrompt: Map.get(json, "appendSubagentSystemPrompt"),
      toolAliases: Map.get(json, "toolAliases"),
      excludeDynamicSections: Map.get(json, "excludeDynamicSections"),
      agents: Map.get(json, "agents"),
      title: Map.get(json, "title"),
      skills: Map.get(json, "skills"),
      webSearchIsolationExemptMcpServers: Map.get(json, "webSearchIsolationExemptMcpServers"),
      promptSuggestions: Map.get(json, "promptSuggestions"),
      agentProgressSummaries: Map.get(json, "agentProgressSummaries"),
      forwardSubagentText: Map.get(json, "forwardSubagentText")
    }
  end
end

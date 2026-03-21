defmodule CeCe.Payload.System do
  @moduledoc """
  System payload, sent at startup with session configuration.

  Currently only handles `subtype: "init"`.
  """

  @behaviour Access

  @type mcp_server :: %{name: String.t(), status: String.t()}

  @type t :: %__MODULE__{
          subtype: :init,
          cwd: String.t(),
          tools: [String.t()],
          mcp_servers: [mcp_server()],
          model: String.t(),
          permission_mode: String.t(),
          slash_commands: [String.t()],
          api_key_source: String.t(),
          claude_code_version: String.t(),
          output_style: String.t(),
          agents: [String.t()],
          skills: [String.t()],
          plugins: [String.t()]
        }

  defstruct [
    :subtype,
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

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(_, _, _), do: raise("CeCe.Payload.System is read-only")

  @impl Access
  def pop(_, _), do: raise("CeCe.Payload.System is read-only")

  def parse(json) do
    %__MODULE__{
      subtype: parse_subtype(json["subtype"]),
      cwd: json["cwd"],
      tools: json["tools"] || [],
      mcp_servers: parse_mcp_servers(json["mcp_servers"]),
      model: json["model"],
      permission_mode: json["permissionMode"],
      slash_commands: json["slash_commands"] || [],
      api_key_source: json["apiKeySource"],
      claude_code_version: json["claude_code_version"],
      output_style: json["output_style"],
      agents: json["agents"] || [],
      skills: json["skills"] || [],
      plugins: json["plugins"] || []
    }
  end

  defp parse_subtype("init"), do: :init
  defp parse_subtype(other), do: other

  defp parse_mcp_servers(nil), do: []

  defp parse_mcp_servers(servers) do
    Enum.map(servers, fn server ->
      %{name: server["name"], status: server["status"]}
    end)
  end
end

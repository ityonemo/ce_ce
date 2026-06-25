defmodule CeCe.Payload.ControlRequest do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:request_id, :request]

  alias CeCe.Payload.ControlRequest.ApplyFlagSettings
  alias CeCe.Payload.ControlRequest.CancelAsyncMessage
  alias CeCe.Payload.ControlRequest.CanUseTool
  alias CeCe.Payload.ControlRequest.ClaudeAuthenticate
  alias CeCe.Payload.ControlRequest.ClaudeOAuthCallback
  alias CeCe.Payload.ControlRequest.Elicitation
  alias CeCe.Payload.ControlRequest.GenerateSessionTitle
  alias CeCe.Payload.ControlRequest.HostAuthTokenRefresh
  alias CeCe.Payload.ControlRequest.HookCallback
  alias CeCe.Payload.ControlRequest.Initialize
  alias CeCe.Payload.ControlRequest.McpAuthenticate
  alias CeCe.Payload.ControlRequest.McpMessage
  alias CeCe.Payload.ControlRequest.McpOAuthCallbackUrl
  alias CeCe.Payload.ControlRequest.McpServerName
  alias CeCe.Payload.ControlRequest.McpSetServers
  alias CeCe.Payload.ControlRequest.MessageRated
  alias CeCe.Payload.ControlRequest.OauthTokenRefresh
  alias CeCe.Payload.ControlRequest.ReadFile
  alias CeCe.Payload.ControlRequest.RemoteControl
  alias CeCe.Payload.ControlRequest.RewindFiles
  alias CeCe.Payload.ControlRequest.RequestUserDialog
  alias CeCe.Payload.ControlRequest.SeedReadState
  alias CeCe.Payload.ControlRequest.SetMaxThinkingTokens
  alias CeCe.Payload.ControlRequest.SetModel
  alias CeCe.Payload.ControlRequest.SetPermissionMode
  alias CeCe.Payload.ControlRequest.SideQuestion
  alias CeCe.Payload.ControlRequest.SimpleControl
  alias CeCe.Payload.ControlRequest.SubmitFeedback
  alias CeCe.Payload.ControlRequest.UltrareviewLaunch

  @type request ::
          Initialize.t()
          | SimpleControl.t()
          | SetPermissionMode.t()
          | SetModel.t()
          | SetMaxThinkingTokens.t()
          | ApplyFlagSettings.t()
          | RewindFiles.t()
          | CancelAsyncMessage.t()
          | SeedReadState.t()
          | RemoteControl.t()
          | SubmitFeedback.t()
          | GenerateSessionTitle.t()
          | SideQuestion.t()
          | UltrareviewLaunch.t()
          | MessageRated.t()
          | McpServerName.t()
          | McpAuthenticate.t()
          | McpOAuthCallbackUrl.t()
          | ClaudeAuthenticate.t()
          | ClaudeOAuthCallback.t()
          | ReadFile.t()
          | McpSetServers.t()
          | McpMessage.t()
          | CanUseTool.t()
          | HookCallback.t()
          | Elicitation.t()
          | RequestUserDialog.t()
          | OauthTokenRefresh.t()
          | HostAuthTokenRefresh.t()

  @type t :: %__MODULE__{
          type: :control_request,
          request_id: String.t(),
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          request: request()
        }

  @derive JSON.Encoder
  defstruct @required_fields ++ [:session_id, :uuid, :parent_tool_use_id, type: :control_request]

  @request_modules %{
    "initialize" => Initialize,
    "interrupt" => SimpleControl,
    "get_settings" => SimpleControl,
    "claude_oauth_wait_for_completion" => SimpleControl,
    "mcp_status" => SimpleControl,
    "get_context_usage" => SimpleControl,
    "reload_plugins" => SimpleControl,
    "reload_skills" => SimpleControl,
    "channel_enable" => SimpleControl,
    "set_permission_mode" => SetPermissionMode,
    "set_model" => SetModel,
    "set_max_thinking_tokens" => SetMaxThinkingTokens,
    "apply_flag_settings" => ApplyFlagSettings,
    "rewind_files" => RewindFiles,
    "cancel_async_message" => CancelAsyncMessage,
    "seed_read_state" => SeedReadState,
    "remote_control" => RemoteControl,
    "submit_feedback" => SubmitFeedback,
    "generate_session_title" => GenerateSessionTitle,
    "side_question" => SideQuestion,
    "ultrareview_launch" => UltrareviewLaunch,
    "message_rated" => MessageRated,
    "mcp_reconnect" => McpServerName,
    "mcp_toggle" => McpServerName,
    "mcp_clear_auth" => McpServerName,
    "mcp_authenticate" => McpAuthenticate,
    "mcp_oauth_callback_url" => McpOAuthCallbackUrl,
    "claude_authenticate" => ClaudeAuthenticate,
    "claude_oauth_callback" => ClaudeOAuthCallback,
    "read_file" => ReadFile,
    "mcp_set_servers" => McpSetServers,
    "mcp_message" => McpMessage,
    "can_use_tool" => CanUseTool,
    "hook_callback" => HookCallback,
    "elicitation" => Elicitation,
    "request_user_dialog" => RequestUserDialog,
    "oauth_token_refresh" => OauthTokenRefresh,
    "host_auth_token_refresh" => HostAuthTokenRefresh
  }

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      request_id: Map.fetch!(json, "request_id"),
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      request: parse_request(Map.fetch!(json, "request"))
    }
  end

  defp parse_request(%{"subtype" => subtype} = json) do
    Map.fetch!(@request_modules, subtype).parse(json)
  end
end

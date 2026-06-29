defmodule CeCe.AuthTest do
  use ExUnit.Case

  alias CeCe.Payload.ControlRequest.ClaudeAuthenticate
  alias CeCe.Payload.ControlRequest.ClaudeOAuthCallback

  alias CeCe.Payload.Assistant
  alias CeCe.Payload.ControlResponse
  alias CeCe.Payload.ControlResponse.Success
  alias CeCe.Payload.KeepAlive

  describe "logout/1" do
    test "is exported with arity 1 (and a default arg)" do
      assert function_exported?(CeCe, :logout, 1)
      assert function_exported?(CeCe, :logout, 0)
    end
  end

  describe "track_auth/2" do
    setup do
      %{state: %CeCe{state: nil, module: CeCe, auth: :unknown}}
    end

    test "a login-success control response (account key) sets :logged_in", %{state: state} do
      msg = %ControlResponse{response: %Success{response: %{"account" => %{"email" => "a@b"}}}}
      assert CeCe.track_auth(msg, state).auth == :logged_in
    end

    test "an assistant authentication_failed sets :logged_out", %{state: state} do
      msg = %Assistant{error: "authentication_failed", message: %Assistant.Message{content: []}}
      assert CeCe.track_auth(msg, %{state | auth: :logged_in}).auth == :logged_out
    end

    test "the claude_authenticate response (manualUrl, no account) leaves auth unchanged",
         %{state: state} do
      msg = %ControlResponse{response: %Success{response: %{"manualUrl" => "https://x"}}}
      assert CeCe.track_auth(msg, state).auth == :unknown
    end

    test "an unrelated message leaves auth unchanged", %{state: state} do
      assert CeCe.track_auth(%KeepAlive{}, %{state | auth: :logged_in}).auth == :logged_in
    end
  end

  describe "Assistant.parse/1 error field" do
    test "keeps the top-level error" do
      json = %{
        "type" => "assistant",
        "error" => "authentication_failed",
        "message" => %{"role" => "assistant", "content" => []}
      }

      assert Assistant.parse(json).error == "authentication_failed"
    end

    test "error is nil when absent" do
      json = %{"type" => "assistant", "message" => %{"role" => "assistant", "content" => []}}
      assert Assistant.parse(json).error == nil
    end
  end

  describe "parse_auth_status/1" do
    test "maps loggedIn:true to :logged_in" do
      json = ~s|{"loggedIn":true,"authMethod":"claude.ai","email":"a@b.com"}|
      assert CeCe.parse_auth_status(json) == :logged_in
    end

    test "maps loggedIn:false to :logged_out" do
      assert CeCe.parse_auth_status(~s|{"loggedIn":false,"authMethod":"none"}|) == :logged_out
    end

    test "maps missing/garbage to :unknown" do
      assert CeCe.parse_auth_status(~s|{"authMethod":"none"}|) == :unknown
      assert CeCe.parse_auth_status("not json") == :unknown
      assert CeCe.parse_auth_status("") == :unknown
    end
  end

  describe "_split_auth_code/1" do
    test "splits code#state" do
      assert CeCe._split_auth_code("the-code#the-state") == {"the-code", "the-state"}
    end

    test "handles a code with no #state" do
      assert CeCe._split_auth_code("just-a-code") == {"just-a-code", ""}
    end

    test "only splits on the first #" do
      assert CeCe._split_auth_code("code#state#extra") == {"code", "state#extra"}
    end
  end

  describe "control request wire envelope" do
    # request_auth/auth_response build a {type, request_id, request} envelope and
    # write it via ProtonStream. Verify the encoded shape of the pieces here
    # (the request structs carry @derive JSON.Encoder).

    test "claude_authenticate encodes with loginWithClaudeAi" do
      encoded =
        %ClaudeAuthenticate{loginWithClaudeAi: true}
        |> JSON.encode!()
        |> JSON.decode!()

      assert encoded == %{"subtype" => "claude_authenticate", "loginWithClaudeAi" => true}
    end

    test "claude_oauth_callback encodes with code + state" do
      encoded =
        %ClaudeOAuthCallback{authorizationCode: "the-code", state: "the-state"}
        |> JSON.encode!()
        |> JSON.decode!()

      assert encoded == %{
               "subtype" => "claude_oauth_callback",
               "authorizationCode" => "the-code",
               "state" => "the-state"
             }
    end

    test "a full control_request envelope round-trips to the expected wire map" do
      envelope =
        %{
          type: "control_request",
          request_id: "req_abc",
          request: %ClaudeAuthenticate{loginWithClaudeAi: true}
        }
        |> JSON.encode!()
        |> JSON.decode!()

      assert envelope == %{
               "type" => "control_request",
               "request_id" => "req_abc",
               "request" => %{
                 "subtype" => "claude_authenticate",
                 "loginWithClaudeAi" => true
               }
             }
    end
  end
end

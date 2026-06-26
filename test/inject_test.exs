defmodule CeCe.InjectTest do
  use ExUnit.Case

  alias CeCe.Payload.ControlRequest
  alias CeCe.Payload.ControlRequest.ClaudeAuthenticate
  alias CeCe.Payload.User

  describe "save_session_id/1" do
    test "caches the struct's session_id in the process dictionary and returns the struct" do
      struct = %User{session_id: "sess-123", message: %User.Message{content: "hi"}}

      assert ^struct = CeCe.save_session_id(struct)
      assert Process.get(:cece_session_id) == "sess-123"
    end

    test "passes non-structs / structs without session_id through unchanged" do
      assert CeCe.save_session_id("raw line\n") == "raw line\n"
      assert CeCe.save_session_id(%{no: :session}) == %{no: :session}
    end

    test "is pipe-friendly (caches and forwards)" do
      Process.delete(:cece_session_id)

      result =
        %User{session_id: "sess-piped", message: %User.Message{content: "x"}}
        |> CeCe.save_session_id()

      assert result.session_id == "sess-piped"
      assert Process.get(:cece_session_id) == "sess-piped"
    end
  end

  describe "ControlRequest.new/1" do
    test "wraps a subtype payload with a fresh v4 request_id and nil session_id" do
      req = ControlRequest.new(%ClaudeAuthenticate{loginWithClaudeAi: true})

      assert %ControlRequest{request: %ClaudeAuthenticate{loginWithClaudeAi: true}} = req
      assert req.session_id == nil
      assert req.type == :control_request

      # v4 UUID format: 8-4-4-4-12 hex, version nibble 4.
      assert req.request_id =~
               ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/

      # each call is unique
      refute ControlRequest.new(%ClaudeAuthenticate{}).request_id == req.request_id
    end

    test "encodes to the expected control_request wire envelope" do
      encoded =
        %ClaudeAuthenticate{loginWithClaudeAi: true}
        |> ControlRequest.new()
        |> JSON.encode!()
        |> JSON.decode!()

      assert %{
               "type" => "control_request",
               "request_id" => rid,
               "request" => %{
                 "subtype" => "claude_authenticate",
                 "loginWithClaudeAi" => true
               }
             } = encoded

      assert is_binary(rid)
    end
  end

  describe "User.new/2" do
    test "wraps content in a user message with a uuid and iso-8601 timestamp" do
      user = User.new("hello")

      assert %User{message: %User.Message{role: :user, content: "hello"}} = user
      assert user.type == :user
      assert {:ok, _, _} = DateTime.from_iso8601(user.timestamp)

      assert user.uuid =~
               ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/
    end

    test "opts override defaults (e.g. session_id)" do
      user = User.new("hi", session_id: "sess-9", uuid: "fixed-uuid")
      assert user.session_id == "sess-9"
      assert user.uuid == "fixed-uuid"
    end

    test "encodes to a user message envelope" do
      encoded = User.new("yo", session_id: "s") |> JSON.encode!() |> JSON.decode!()

      assert encoded["type"] == "user"
      assert encoded["session_id"] == "s"
      assert encoded["message"] == %{"role" => "user", "content" => "yo"}
    end
  end
end

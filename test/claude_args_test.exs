defmodule CeCe.ClaudeArgsTest do
  use ExUnit.Case, async: true

  # The argv passed to the `claude` subprocess. Extracted so the flags can be
  # unit-tested without spawning anything (the fake transport only captures the
  # command name, not its args).

  test "base args request continuous stream-json I/O" do
    args = CeCe.claude_args([])

    assert "--continue" in args
    assert "--output-format" in args
    assert "stream-json" in args
    assert "--input-format" in args
    assert "--verbose" in args
  end

  test "no permission-prompt flag by default" do
    refute "--permission-prompt-tool" in CeCe.claude_args([])
  end

  test "permission_prompt: :stdio delegates tool permission over the stream" do
    args = CeCe.claude_args(permission_prompt: :stdio)

    assert ["--permission-prompt-tool", "stdio"] ==
             Enum.slice(args, arg_index(args, "--permission-prompt-tool"), 2)
  end

  test "system_prompt is appended as --system-prompt" do
    args = CeCe.claude_args(system_prompt: "be terse")

    assert ["--system-prompt", "be terse"] ==
             Enum.slice(args, arg_index(args, "--system-prompt"), 2)
  end

  test "no model flag by default" do
    refute "--model" in CeCe.claude_args([])
  end

  test "model is appended as --model" do
    args = CeCe.claude_args(model: :sonnet)

    assert ["--model", "sonnet"] ==
             Enum.slice(args, arg_index(args, "--model"), 2)
  end

  test "no tool restrictions by default" do
    args = CeCe.claude_args([])

    refute "--disallowed-tools" in args
    refute "--settings" in args
  end

  test "disallowed_tools is appended as --disallowed-tools" do
    # A list rather than a pre-joined string: the caller names tools, and
    # how the CLI wants them punctuated is this module's business.
    args = CeCe.claude_args(disallowed_tools: ["SendMessage", "ListAgents"])

    assert ["--disallowed-tools", "SendMessage,ListAgents"] ==
             Enum.slice(args, arg_index(args, "--disallowed-tools"), 2)
  end

  test "a single disallowed tool need not be wrapped in a list" do
    args = CeCe.claude_args(disallowed_tools: "SendMessage")

    assert ["--disallowed-tools", "SendMessage"] ==
             Enum.slice(args, arg_index(args, "--disallowed-tools"), 2)
  end

  test "an empty list of disallowed tools passes no flag" do
    refute "--disallowed-tools" in CeCe.claude_args(disallowed_tools: [])
  end

  test "settings is encoded and appended as --settings" do
    # Always encoded, never passed through: the CLI reads a string as
    # either a path or JSON depending on what it looks like, and a
    # caller handing over data should not have to know which it got.
    args = CeCe.claude_args(settings: %{permissions: %{deny: ["SendMessage"]}})

    assert [_flag, json] = Enum.slice(args, arg_index(args, "--settings"), 2)
    assert JSON.decode!(json) == %{"permissions" => %{"deny" => ["SendMessage"]}}
  end

  test "nested settings survive the encoding" do
    # The shapes the CLI wants are nested objects, so this is the case
    # that matters -- a top-level-only conversion would lose them.
    args =
      CeCe.claude_args(
        settings: %{permissions: %{deny: ["SendMessage"], allow: ["Read"]}, env: %{"A" => "1"}}
      )

    assert [_flag, json] = Enum.slice(args, arg_index(args, "--settings"), 2)

    assert JSON.decode!(json) == %{
             "permissions" => %{"deny" => ["SendMessage"], "allow" => ["Read"]},
             "env" => %{"A" => "1"}
           }
  end

  defp arg_index(args, flag), do: Enum.find_index(args, &(&1 == flag))
end

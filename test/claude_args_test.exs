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

  defp arg_index(args, flag), do: Enum.find_index(args, &(&1 == flag))
end

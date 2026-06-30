defmodule CeCe.JsonCallbacksTest do
  use ExUnit.Case

  # Optional callbacks threaded in via init_arg: on_json_string is invoked with
  # the raw JSON line (before parse), on_json_map with the decoded payload struct
  # (after a successful parse). Both default to nil (no-op).

  @line ~s|{"type":"keep_alive","session_id":"s","uuid":"u","parent_tool_use_id":null}|

  defp state(callbacks) do
    struct!(CeCe, [state: self(), module: CeCe, buffer: ""] ++ callbacks)
  end

  test "on_json_string receives the raw JSON line" do
    me = self()
    CeCe.handle_stdout(@line <> "\n", state(on_json_string: &send(me, {:raw, &1})))

    assert_receive {:raw, @line}
  end

  test "on_json_map receives the parsed payload struct" do
    me = self()
    CeCe.handle_stdout(@line <> "\n", state(on_json_map: &send(me, {:map, &1})))

    assert_receive {:map, %CeCe.Payload.KeepAlive{}}
  end
end

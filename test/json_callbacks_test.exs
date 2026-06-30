defmodule CeCe.JsonCallbacksTest do
  use ExUnit.Case

  # Optional callbacks threaded in via init_arg: on_json_string is invoked with
  # the raw JSON line (before decode), on_json_map with the decoded JSON map
  # (after JSON.decode, before CeCe.Payload.parse). Both default to nil (no-op).
  #
  # Each callback accepts three forms:
  #   - 1-arity fun           -> fun.(value)
  #   - 2-arity fun           -> fun.(value, inner_state)
  #   - {mod, fun, extra}     -> apply(mod, fun, [value, inner_state | extra])
  #
  # Here the inner handler state (state.state) is the test pid, so the 2-arity
  # and MFA forms hand the test pid back to us as the second argument.

  @line ~s|{"type":"keep_alive","session_id":"s","uuid":"u","parent_tool_use_id":null}|

  defp state(callbacks) do
    struct!(CeCe, [state: self(), module: CeCe, buffer: ""] ++ callbacks)
  end

  # An MFA target: forwards (value, pid, tag) back to the pid.
  def relay(value, pid, tag), do: send(pid, {tag, value})

  describe "1-arity form (value only)" do
    test "on_json_string receives the raw JSON line" do
      me = self()
      CeCe.handle_stdout(@line <> "\n", state(on_json_string: &send(me, {:raw, &1})))

      assert_receive {:raw, @line}
    end

    test "on_json_map receives the decoded JSON map" do
      me = self()
      CeCe.handle_stdout(@line <> "\n", state(on_json_map: &send(me, {:map, &1})))

      assert_receive {:map, %{"type" => "keep_alive", "session_id" => "s"}}
    end
  end

  describe "2-arity form (value + inner state)" do
    test "on_json_string receives the raw line and the inner handler state" do
      me = self()
      cb = fn raw, inner -> send(inner, {:raw2, raw, inner}) end
      CeCe.handle_stdout(@line <> "\n", state(on_json_string: cb))

      assert_receive {:raw2, @line, ^me}
    end

    test "on_json_map receives the decoded map and the inner handler state" do
      me = self()
      cb = fn map, inner -> send(inner, {:map2, map, inner}) end
      CeCe.handle_stdout(@line <> "\n", state(on_json_map: cb))

      assert_receive {:map2, %{"type" => "keep_alive"}, ^me}
    end
  end

  describe "{module, function, extra_args} form" do
    test "on_json_string applies value + inner state + extra args" do
      mfa = {__MODULE__, :relay, [:raw_mfa]}
      CeCe.handle_stdout(@line <> "\n", state(on_json_string: mfa))

      assert_receive {:raw_mfa, @line}
    end

    test "on_json_map applies value + inner state + extra args" do
      mfa = {__MODULE__, :relay, [:map_mfa]}
      CeCe.handle_stdout(@line <> "\n", state(on_json_map: mfa))

      assert_receive {:map_mfa, %{"type" => "keep_alive"}}
    end
  end
end

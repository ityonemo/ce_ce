defmodule CeCe.FakeTest do
  use ExUnit.Case

  # `fake: pid` (a start_link opt) swaps the real `claude` subprocess for
  # ProtonStream's fake transport: no binary is spawned, auth detection is
  # skipped (treated as logged in), and the test injects stdout frames that
  # drive the real pipeline.

  defmodule Handler do
    @behaviour CeCe
    def init(init_arg), do: {:ok, init_arg[:owner]}
    @impl CeCe
    def handle_message(message, owner) do
      send(owner, {:message, message})
      {:noreply, owner}
    end
  end

  test "fake: opens a fake transport and reports logged-in without a real claude" do
    {:ok, ps} = CeCe.start_link(Handler, [owner: self()], fake: self())

    assert ^ps = ProtonStream.Fake.assert_opened("claude")
    assert CeCe.logged_in?(ps)
  end

  test "an injected stdout line drives the real pipeline to the handler" do
    me = self()
    {:ok, ps} = CeCe.start_link(Handler, [owner: me], fake: me)
    ^ps = ProtonStream.Fake.assert_opened("claude")

    line = ~s|{"type":"keep_alive","session_id":"s","uuid":"u","parent_tool_use_id":null}|
    ProtonStream.Fake.send_data(ps, ProtonStream.Fake.stdout_frame(line <> "\n"))

    assert_receive {:message, %CeCe.Payload.KeepAlive{session_id: "s"}}
  end
end

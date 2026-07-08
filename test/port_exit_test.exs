defmodule CeCe.PortExitTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  # A transport-level `{:EXIT, port, :normal}` must be absorbed by CeCe (with a
  # "lost connection" warning), not forwarded to the callback module (whose
  # default handle_info would log it as an "unexpected message").

  defmodule Handler do
    @behaviour CeCe
    def init(init_arg), do: {:ok, init_arg[:owner]}

    @impl CeCe
    def handle_message(_message, owner), do: {:noreply, owner}

    # If CeCe forwards a message here, the test pid hears about it.
    def handle_info(msg, owner) do
      send(owner, {:forwarded, msg})
      {:noreply, owner}
    end
  end

  test "a port EXIT (:normal) is logged and swallowed, not forwarded to the callback" do
    me = self()
    {:ok, ps} = CeCe.start_link(Handler, [owner: me], fake: me)
    ^ps = ProtonStream.Fake.assert_opened("claude")

    port = Port.open({:spawn, "true"}, [:binary])

    log =
      capture_log(fn ->
        send(ps, {:EXIT, port, :normal})
        # Let the message be processed before we inspect the log / mailbox.
        _ = :sys.get_state(ps)
      end)

    assert log =~ "claude code process has lost connection"
    refute_receive {:forwarded, {:EXIT, ^port, :normal}}, 200
    # The agent is still alive after absorbing the exit.
    assert Process.alive?(ps)
  end
end

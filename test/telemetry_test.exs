defmodule CeCe.TelemetryTest do
  use ExUnit.Case

  @event [:ce_ce, :message, :received]

  setup do
    handler = "test-#{System.unique_integer([:positive])}"
    test_pid = self()

    :telemetry.attach(
      handler,
      @event,
      fn event, measurements, metadata, _config ->
        send(test_pid, {:telemetry, event, measurements, metadata})
      end,
      nil
    )

    on_exit(fn -> :telemetry.detach(handler) end)
    :ok
  end

  test "emits [:ce_ce, :message, :received] with the raw decoded map before parsing" do
    json = ~s|{"type":"keep_alive","session_id":"s","uuid":"u","parent_tool_use_id":null}|
    state = %CeCe{state: self(), module: CeCe, buffer: ""}

    CeCe.handle_stdout(json <> "\n", state)

    assert_receive {:telemetry, @event, measurements, metadata}
    assert is_integer(measurements.system_time)
    assert metadata.raw == JSON.decode!(json)
    assert metadata.json == json
  end

  test "emits the raw map even when the message type is unknown (parse would crash)" do
    # An unknown type makes CeCe.Message.parse/1 raise; the telemetry event must
    # still have fired with the raw payload (it is emitted before parse).
    json = ~s|{"type":"some_future_type","session_id":"s","uuid":"u"}|
    state = %CeCe{state: self(), module: CeCe, buffer: ""}

    catch_error(CeCe.handle_stdout(json <> "\n", state))

    assert_receive {:telemetry, @event, _measurements, metadata}
    assert metadata.raw["type"] == "some_future_type"
  end
end

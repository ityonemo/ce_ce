defmodule Mix.Tasks.Claude do
  @moduledoc """
  Interactive Claude Code session with pretty-printed struct output.

  ## Usage

      mix claude

  Then type prompts on stdin. Parsed message structs are printed to stdout.
  Press Ctrl+D to exit.
  """

  use Mix.Task

  @shortdoc "Interactive Claude Code session"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    {:ok, pid} = CeCe.start_link(self(), [])

    IO.puts(:stderr, "Claude Code session started. Type prompts, Ctrl+D to exit.\n")

    stdin_reader = spawn_link(fn -> read_stdin(self(), pid) end)
    loop(pid, stdin_reader, _eof_received = false)
  end

  defp read_stdin(parent, cece_pid) do
    case IO.gets("") do
      :eof ->
        send(parent, :eof)

      {:error, reason} ->
        send(parent, {:stdin_error, reason})

      line ->
        CeCe.send_prompt(cece_pid, String.trim_trailing(line, "\n"))
        read_stdin(parent, cece_pid)
    end
  end

  defp loop(pid, stdin_reader, eof_received) do
    receive do
      message when is_struct(message) ->
        IO.puts(inspect(message, pretty: true, limit: :infinity))
        loop(pid, stdin_reader, eof_received)

      {:cece_stderr, data} ->
        IO.write(:stderr, data)
        loop(pid, stdin_reader, eof_received)

      :eof ->
        # EOF received, but keep listening for messages
        loop(pid, stdin_reader, true)

      {:stdin_error, reason} ->
        IO.puts(:stderr, "Error reading stdin: #{inspect(reason)}")
        GenServer.stop(pid)
    after
      # Only timeout after EOF received
      if(eof_received, do: 5000, else: :infinity) ->
        GenServer.stop(pid)
        IO.puts(:stderr, "\nSession ended.")
    end
  end
end

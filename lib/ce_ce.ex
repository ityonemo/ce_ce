defmodule CeCe do
  @moduledoc """
  Claude Code Elixir Client.

  A GenServer library wrapping the Claude Code CLI using ProtonStream
  for process management.

  ## Simple Mode

      {:ok, pid} = CeCe.start_link(self(), [])
      CeCe.send_prompt(pid, "Hello, Claude!")

      receive do
        %CeCe.Message{type: :assistant, payload: payload} ->
          IO.inspect(payload.content)
      end

  The handler PID receives `%CeCe.Message{}` structs and `{:cece_stderr, binary}` tuples.

  ## Callback Module Mode

      defmodule MyHandler do
        use GenServer
        @behaviour CeCe

        def start_link(opts), do: CeCe.start_link(__MODULE__, opts, [])

        @impl GenServer
        def init(_), do: {:ok, %{messages: []}}

        @impl CeCe
        def handle_message(message, state) do
          {:noreply, %{state | messages: [message | state.messages]}}
        end
      end

  Implement `@behaviour CeCe` for `handle_message/2`.
  For `handle_stderr/2`, add `@behaviour ProtonStream`.

  ## Options

  - `:cwd` - Working directory for Claude Code (default: `File.cwd!()`)
  - `:name` - GenServer name registration
  - `:system_prompt` - Optional system prompt passed to Claude CLI
  """

  use GenServer
  @behaviour ProtonStream

  # Behaviour callbacks for user modules.

  @callback handle_message(message :: CeCe.Message.t(), state :: term()) ::
              {:noreply, state :: term()}
              | {:noreply, state :: term(), timeout() | :hibernate | {:continue, term()}}
              | {:stop, reason :: term(), state :: term()}

  # 1. BOILERPLATE & INITIALIZATION

  defstruct [:state, module: __MODULE__, buffer: ""]

  @type state :: %__MODULE__{
          buffer: String.t(),
          state: term(),
          module: module()
        }

  @spec start_link(pid(), keyword()) :: GenServer.on_start()
  @spec start_link(module(), term(), keyword()) :: GenServer.on_start()
  def start_link(module \\ nil, handler, opts) do
    cwd = Keyword.get(opts, :cwd, File.cwd!())
    genserver_opts = Keyword.take(opts, [:name])

    ProtonStream.start_link(
      __MODULE__,
      "claude",
      ~w[--continue --output-format stream-json --input-format stream-json --print --verbose] ++
        system_prompt(opts),
      {module, handler},
      [cd: cwd] ++ genserver_opts
    )
  end

  defp system_prompt(opts) do
    case Keyword.get(opts, :system_prompt) do
      nil -> []
      prompt -> ["--system-prompt", prompt]
    end
  end

  @impl GenServer
  @spec init({module(), term}) ::
          {:ok, state()}
          | {:ok, state(), timeout() | :hibernate | {:continue, continue_arg :: term()}}
          | :ignore
          | {:stop, reason :: term()}
  @spec init({nil, pid}) :: {:ok, state()}
  def init({module, init_arg}) do
    if module do
      case module.init(init_arg) do
        {:ok, inner_state} ->
          {:ok, %__MODULE__{module: module, state: inner_state}}

        {:ok, inner_state, extra} ->
          {:ok, %__MODULE__{module: module, state: inner_state}, extra}

        other ->
          other
      end
    else
      {:ok, %__MODULE__{state: init_arg}}
    end
  end

  # 2. API + IMPLEMENTATIONS

  @spec send_prompt(GenServer.server(), String.t()) :: :ok
  def send_prompt(server, prompt) do
    json =
      JSON.encode!(%{
        type: "user",
        message: %{
          role: "user",
          content: prompt
        }
      })

    ProtonStream.command(server, [json, "\n"])
  end

  # Simple mode callback: send message to handler PID
  def handle_message(message, handler) when is_pid(handler) do
    send(handler, message)
    {:noreply, handler}
  end

  # 3. PROTONSTREAM CALLBACKS

  @impl ProtonStream
  def handle_stdout(data, state) do
    {new_buffer, new_state} = process_buffer(state.buffer <> data, state)
    {:noreply, %{new_state | buffer: new_buffer}}
  end

  @impl ProtonStream
  def handle_stderr(data, state) when state.module == __MODULE__ do
    send(state.state, {:cece_stderr, data})

    {:noreply, state}
  end

  def handle_stderr(data, %{module: module} = state) do
    if function_exported?(module, :handle_stderr, 2) do
      case module.handle_stderr(data, state.state) do
        {:noreply, new_inner_state} ->
          {:noreply, %{state | state: new_inner_state}}

        {:noreply, new_inner_state, extra} ->
          {:noreply, %{state | state: new_inner_state}, extra}

        {:stop, reason, new_inner_state} ->
          {:stop, reason, %{state | state: new_inner_state}}
      end
    else
      {:noreply, state}
    end
  end

  @impl ProtonStream
  def handle_exit(reason, state) do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_continue(continue_arg, state) when state.module != __MODULE__ do
    if function_exported?(state.module, :handle_continue, 2) do
      case state.module.handle_continue(continue_arg, state.state) do
        {:noreply, new_inner_state} ->
          {:noreply, %{state | state: new_inner_state}}

        {:noreply, new_inner_state, extra} ->
          {:noreply, %{state | state: new_inner_state}, extra}

        {:stop, reason, new_inner_state} ->
          {:stop, reason, %{state | state: new_inner_state}}
      end
    else
      {:noreply, state}
    end
  end

  @impl GenServer
  def terminate(reason, state) when state.module != __MODULE__ do
    if function_exported?(state.module, :terminate, 2) do
      state.module.terminate(reason, state.state)
    else
      :ok
    end
  end

  def terminate(_reason, _state), do: :ok

  # 4. HELPER FUNCTIONS

  defp process_buffer(buffer, state) do
    case String.split(buffer, "\n", parts: 2) do
      [complete_json, rest] ->
        new_state =
          case parse_json(complete_json) do
            {:ok, message} ->
              deliver_message(message, state)

            {:error, _reason} ->
              state
          end

        process_buffer(rest, new_state)

      [incomplete] ->
        {incomplete, state}
    end
  end

  defp parse_json(""), do: {:error, :empty}

  defp parse_json(json_string) do
    case :json.decode(json_string) do
      map when is_map(map) ->
        {:ok, CeCe.Message.parse(map)}
    end
  rescue
    _ -> {:error, :invalid_json}
  end

  defp deliver_message(message, state) do
    case state.module.handle_message(message, state.state) do
      {:noreply, new_inner_state} ->
        %{state | state: new_inner_state}

      {:noreply, new_inner_state, _extra} ->
        %{state | state: new_inner_state}

      {:stop, reason, new_inner_state} ->
        throw({:stop, reason, %{state | state: new_inner_state}})
    end
  end

  # 5. ROUTER

  # Forward GenServer calls to user module
  @impl GenServer
  def handle_call(msg, from, state) when state.module != __MODULE__ do
    if function_exported?(state.module, :handle_call, 3) do
      case state.module.handle_call(msg, from, state.state) do
        {:reply, reply, new_inner_state} ->
          {:reply, reply, %{state | state: new_inner_state}}

        {:reply, reply, new_inner_state, extra} ->
          {:reply, reply, %{state | state: new_inner_state}, extra}

        {:noreply, new_inner_state} ->
          {:noreply, %{state | state: new_inner_state}}

        {:noreply, new_inner_state, extra} ->
          {:noreply, %{state | state: new_inner_state}, extra}

        {:stop, reason, reply, new_inner_state} ->
          {:stop, reason, reply, %{state | state: new_inner_state}}

        {:stop, reason, new_inner_state} ->
          {:stop, reason, %{state | state: new_inner_state}}
      end
    else
      {:reply, {:error, :not_implemented}, state}
    end
  end

  @impl GenServer
  def handle_cast(msg, state) when state.module != __MODULE__ do
    if function_exported?(state.module, :handle_cast, 2) do
      case state.module.handle_cast(msg, state.state) do
        {:noreply, new_inner_state} ->
          {:noreply, %{state | state: new_inner_state}}

        {:noreply, new_inner_state, extra} ->
          {:noreply, %{state | state: new_inner_state}, extra}

        {:stop, reason, new_inner_state} ->
          {:stop, reason, %{state | state: new_inner_state}}
      end
    else
      {:noreply, state}
    end
  end

  @impl GenServer
  def handle_info(msg, state) when state.module != __MODULE__ do
    if function_exported?(state.module, :handle_info, 2) do
      case state.module.handle_info(msg, state.state) do
        {:noreply, new_inner_state} ->
          {:noreply, %{state | state: new_inner_state}}

        {:noreply, new_inner_state, extra} ->
          {:noreply, %{state | state: new_inner_state}, extra}

        {:stop, reason, new_inner_state} ->
          {:stop, reason, %{state | state: new_inner_state}}
      end
    else
      {:noreply, state}
    end
  end
end

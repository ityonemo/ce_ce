defmodule CeCe do
  @moduledoc """
  Claude Code Elixir Client.

  A GenServer library wrapping the Claude Code CLI using ProtonStream
  for process management.

  ## Simple Mode

      {:ok, pid} = CeCe.start_link(self(), [])
      CeCe.send_prompt(pid, "Hello, Claude!")

      receive do
        %CeCe.Payload.Assistant{message: message} ->
          IO.inspect(message.content)
      end

  The handler PID receives `CeCe.Payload.t()` structs and `{:cece_stderr, binary}` tuples.

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

  @callback handle_message(message :: CeCe.Payload.t(), state :: term()) ::
              {:noreply, state :: term()}
              | {:noreply, state :: term(), timeout() | :hibernate | {:continue, term()}}
              | {:stop, reason :: term(), state :: term()}

  # 1. BOILERPLATE & INITIALIZATION

  defstruct [:state, module: __MODULE__, buffer: "", auth: :unknown]

  @type auth :: :logged_in | :logged_out | :unknown

  @type state :: %__MODULE__{
          buffer: String.t(),
          state: term(),
          module: module(),
          auth: auth()
        }

  @spec start_link(pid(), keyword()) :: GenServer.on_start()
  @spec start_link(module(), term(), keyword()) :: GenServer.on_start()
  def start_link(module \\ nil, handler, opts) do
    cwd = Keyword.get(opts, :cwd, File.cwd!())
    genserver_opts = Keyword.take(opts, [:name])

    ProtonStream.start_link(
      __MODULE__,
      "claude",
      ~w[--continue --output-format stream-json --input-format stream-json --verbose] ++
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
    auth = detect_auth()

    if module do
      case module.init(init_arg) do
        {:ok, inner_state} ->
          {:ok, %__MODULE__{module: module, state: inner_state, auth: auth}}

        {:ok, inner_state, extra} ->
          {:ok, %__MODULE__{module: module, state: inner_state, auth: auth}, extra}

        other ->
          other
      end
    else
      {:ok, %__MODULE__{state: init_arg, auth: auth}}
    end
  end

  # Detect whether the `claude` CLI is authenticated by running its own
  # out-of-band status command. The stream-json `system/init` message cannot
  # distinguish logged-in from logged-out (it reports apiKeySource "none" in
  # both), so this subprocess is the only reliable signal. It reads the same
  # CLAUDE_CONFIG_DIR the session uses (inherited from the BEAM env).
  defp detect_auth do
    case System.cmd("claude", ["auth", "status", "--json"], stderr_to_stdout: true) do
      {output, 0} -> parse_auth_status(output)
      _ -> :unknown
    end
  rescue
    _ -> :unknown
  end

  @doc false
  # Maps the JSON from `claude auth status --json` to an auth atom. Public for
  # testing as a pure function.
  def parse_auth_status(json) do
    case JSON.decode(json) do
      {:ok, %{"loggedIn" => true}} -> :logged_in
      {:ok, %{"loggedIn" => false}} -> :logged_out
      _ -> :unknown
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

  @doc """
  Whether the wrapped `claude` CLI was authenticated at startup.

  Reflects the auth state detected in `init/1`; returns `:unknown` if the check
  could not run.
  """
  @spec logged_in?(GenServer.server()) :: boolean()
  def logged_in?(server), do: GenServer.call(server, :cece_logged_in?)

  @doc """
  Begin an interactive Claude login over the live session.

  Injects a `claude_authenticate` control request. Fire-and-forget: the CLI's
  `control_response` (carrying `manualUrl`) arrives via the normal message path
  (`handle_message`). Open `manualUrl`, authorize, and pass the resulting
  `code#state` string to `auth_response/2`.
  """
  @spec request_auth(GenServer.server()) :: :ok
  def request_auth(server) do
    control_request(server, %CeCe.Payload.ControlRequest.ClaudeAuthenticate{
      loginWithClaudeAi: true
    })
  end

  @doc """
  Complete an interactive Claude login.

  `pasted` is the `code#state` string shown after authorizing `manualUrl`
  (the part before `#` is the authorization code, after is the state). Injects a
  `claude_oauth_callback` control request; the success `control_response` (with
  account info) arrives via the normal message path.
  """
  @spec auth_response(GenServer.server(), String.t()) :: :ok
  def auth_response(server, pasted) when is_binary(pasted) do
    {code, state} = split_auth_code(pasted)

    control_request(server, %CeCe.Payload.ControlRequest.ClaudeOAuthCallback{
      authorizationCode: code,
      state: state
    })
  end

  @doc false
  # Splits the pasted `code#state` string into `{code, state}`. Public for
  # testing.
  def split_auth_code(pasted) do
    case String.split(pasted, "#", parts: 2) do
      [code, state] -> {code, state}
      [code] -> {code, ""}
    end
  end

  # Inject a control_request envelope onto the CLI's stdin (fire-and-forget).
  defp control_request(server, request_struct) do
    json =
      JSON.encode!(%{
        type: "control_request",
        request_id: gen_request_id(),
        request: request_struct
      })

    ProtonStream.command(server, [json, "\n"])
  end

  defp gen_request_id, do: "req_" <> Base.encode16(:crypto.strong_rand_bytes(8), case: :lower)

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
    case JSON.decode(json_string) do
      {:ok, map} when is_map(map) ->
        # Emit telemetry with the raw decoded map BEFORE parsing, so every
        # inbound message is observable even if CeCe.Payload.parse/1 raises
        # (e.g. an unknown type or a key the schema renamed).
        :telemetry.execute(
          [:ce_ce, :message, :received],
          %{system_time: System.system_time()},
          %{raw: map, json: json_string}
        )

        {:ok, CeCe.Payload.parse(map)}

      {:error, _} ->
        {:error, :invalid_json}
    end
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

  # CeCe-owned call: report the auth state detected at startup. Matched before
  # the user-module forwarding clause so it works in both modes.
  @impl GenServer
  def handle_call(:cece_logged_in?, _from, state) do
    {:reply, state.auth == :logged_in, state}
  end

  # Forward GenServer calls to user module
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

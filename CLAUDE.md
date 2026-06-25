# CeCe - Claude Code Elixir Client

## Overview

A GenServer library wrapping the Claude Code CLI using ProtonStream for process management.

## CLI Invocation

```bash
claude --continue --output-format stream-json --input-format stream-json --verbose
```

**Important**: `--input-format stream-json` is required for interactive/multi-shot sessions; the SDK transport drives the same invocation (no `--print`).

## JSON Parsing

Use Erlang's `:json` module for streaming JSON parsing. The CLI outputs newline-delimited JSON objects that need to be parsed incrementally as data arrives.

## Input Format

When using `--input-format stream-json`, send newline-delimited JSON:

```json
{"type":"user","message":{"role":"user","content":"your prompt here"}}
```

## Message Structure

### Common Fields

All messages share these fields:
- `type` - Message type: `"system"`, `"assistant"`, `"user"`
- `session_id` - Session UUID
- `uuid` - Message UUID
- `parent_tool_use_id` - Parent tool use ID (nullable)

### Payload Types (Bestiary)

#### System/Init (`type: "system", subtype: "init"`)
Sent once at startup with session configuration:
- `cwd` - Working directory
- `tools` - Available tools list
- `mcp_servers` - MCP server status list
- `model` - Model identifier
- `permissionMode` - Permission mode
- `slash_commands` - Available slash commands
- `apiKeySource` - API key source
- `claude_code_version` - CLI version
- `output_style` - Output style
- `agents` - Available agents
- `skills`, `plugins` - Extensions

#### Assistant (`type: "assistant"`)
Claude's responses:
- `message.content` - Array of content blocks:
  - `type: "text"` - Text response with `text` field
  - `type: "tool_use"` - Tool invocation with `id`, `name`, `input`
- `message.usage` - Token usage info
- `message.stop_reason` - Why generation stopped (nullable during streaming)

#### User/Tool Result (`type: "user"`)
Tool execution results:
- `message.content` - Array with `tool_result` blocks
- `tool_use_result` - Detailed result:
  - `stdout`, `stderr` - Command output
  - `interrupted` - Whether execution was interrupted
  - `isImage` - Whether result is an image

## Dependencies

- `proton_stream` - OS process management with bidirectional stdio

## Usage Modes

### Simple Mode (PID Handler)

Messages are sent to a handler PID:

```elixir
{:ok, pid} = CeCe.start_link(handler: self(), system_message: "Be concise")
CeCe.send_prompt(pid, "Hello!")

receive do
  %CeCe.Message{type: :assistant} = msg -> IO.inspect(msg.payload.content)
end
```

### Callback Module Mode

Implement `@behaviour CeCe` for structured message handling:

```elixir
defmodule MyHandler do
  use GenServer
  @behaviour CeCe

  def start_link(opts), do: CeCe.start_link(__MODULE__, opts, [])

  @impl GenServer
  def init(_), do: {:ok, %{messages: []}}

  # CeCe callbacks - receive %CeCe.Message{} structs
  @impl CeCe
  def handle_system(message, state) do
    IO.puts("Model: #{message.payload.model}")
    {:noreply, state}
  end

  @impl CeCe
  def handle_assistant(message, state) do
    {:noreply, %{state | messages: [message | state.messages]}}
  end

  @impl CeCe
  def handle_user(message, state) do
    {:noreply, state}
  end

  # Standard GenServer callbacks also work
  @impl GenServer
  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end
end
```

The callback module pattern:
- `handle_system/2`, `handle_assistant/2`, `handle_user/2` - CeCe callbacks (all optional)
- `handle_call/3`, `handle_cast/2`, `handle_info/2` - Standard GenServer callbacks (optional)

## Router Pattern for GenServers

**IMPORTANT:** All GenServers and GenServer-like modules (LiveViews, etc.) should follow the Router Pattern for code organization.

The Router Pattern organizes GenServer code into clear sections that make it easy to understand the API and find implementations.

### Structure

```elixir
defmodule MyGenServer do
  use GenServer

  # 1. BOILERPLATE & INITIALIZATION
  # - child_spec, start_link, init
  # - These rarely change once written

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(args.id))
  end

  def init(args) do
    {:ok, %{id: args.id, data: nil}}
  end

  # 2. API + IMPLEMENTATIONS
  # - Each API function is immediately followed by its implementation
  # - API functions are one-liners that delegate to GenServer.call/cast
  # - Implementation functions contain the actual logic
  # - Declare @spec for all public API functions

  @spec get_data(id :: term()) :: term()
  def get_data(id) do
    GenServer.call(via_tuple(id), :get_data)
  end

  defp get_data_impl(_from, state) do
    {:reply, state.data, state}
  end

  @spec set_data(id :: term(), data :: term()) :: :ok
  def set_data(id, data) do
    GenServer.call(via_tuple(id), {:set_data, data})
  end

  defp set_data_impl(data, _from, state) do
    {:reply, :ok, %{state | data: data}}
  end

  # 3. HELPER FUNCTIONS (if needed)
  # - Pure functions used by implementations
  # - Via tuples, formatters, etc.

  defp via_tuple(id) do
    {:via, Registry, {MyRegistry, id}}
  end

  # 4. ROUTER (Boilerplate at bottom - write once, never think about again)
  # - Simple pattern matching that routes to implementations
  # - One-to-one correspondence with API functions above

  def handle_call(:get_data, from, state) do
    get_data_impl(from, state)
  end

  def handle_call({:set_data, data}, from, state) do
    set_data_impl(data, from, state)
  end
end
```

### Key Rules

1. **API functions are one-liners** that call `GenServer.call/cast/info`
2. **Implementation functions (defp *_impl)** are placed directly below their corresponding API function
3. **For handle_call**: Implementation takes `(args..., from, state)`
4. **For handle_cast**: Implementation takes `(args..., state)` - NO 'from' parameter
5. **For handle_info**: Implementation takes `(message_payload, state)`
6. **Router at bottom** is pure boilerplate - pattern match and delegate
7. **Always pass full GenServer return tuples** from implementations: `{:reply, ...}`, `{:noreply, ...}`, `{:stop, ...}`
8. **Prefer GenServer.call over GenServer.cast** - Use `call` with `:ok` return unless there's a specific performance requirement or deadlock risk

### Benefits

- **Locality**: API declaration, spec, and implementation are adjacent
- **Clarity**: Router is obvious mechanical translation, no logic hidden there
- **Testability**: Implementation functions are easily testable
- **Maintainability**: Each section has a clear purpose
- **Consistency**: Once you learn the pattern, all GenServers look the same

### Anti-patterns to Avoid

- Putting logic inside `handle_call/cast/info` clauses
- Separating API functions from their implementations
- Passing `from` to cast implementations (casts don't have a 'from')
- Passing unnecessary state data that's already in state (like `state.module`)
- Making router anything other than pure pattern-match-and-delegate

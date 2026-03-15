# CeCe

Claude Code Elixir Client - a GenServer library wrapping the Claude Code CLI using ProtonStream for process management.

## Installation

```elixir
def deps do
  [
    {:ce_ce, "~> 0.1.0"}
  ]
end
```

## Usage

### Simple Mode

Messages are sent to a handler PID:

```elixir
{:ok, pid} = CeCe.start_link(self(), [])
CeCe.send_prompt(pid, "Hello, Claude!")

receive do
  %CeCe.Message{type: :assistant, payload: payload} ->
    IO.inspect(payload.content)
end
```

The handler PID receives `%CeCe.Message{}` structs and `{:cece_stderr, binary}` tuples.

### Callback Module Mode

Implement `@behaviour CeCe` for structured message handling:

```elixir
defmodule MyHandler do
  use GenServer
  @behaviour CeCe

  def start_link(opts), do: CeCe.start_link(__MODULE__, opts, [])

  @impl GenServer
  def init(_), do: {:ok, %{}}

  @impl CeCe
  def handle_message(message, state) do
    IO.inspect(message)
    {:noreply, state}
  end
end
```

```
iex> {:ok, pid} = MyHandler.start_link([])
{:ok, #PID<0.123.0>}
iex> CeCe.send_prompt(pid, "please describe this repo")
:ok
%CeCe.Message{
  type: :system,
  session_id: "bd8c53c0-82a8-4421-9fbd-64fc39be1502",
  uuid: "16d1a673-e157-4493-9e09-14a89618ad7f",
  parent_tool_use_id: nil,
  payload: %CeCe.Payload.System{
    subtype: :init,
    cwd: "/home/ityonemo/code/ce_ce",
    tools: ["Task", "TaskOutput", "Bash", "Glob", "Grep", "ExitPlanMode",
     "Read", "Edit", "Write", "NotebookEdit", "WebFetch", "TodoWrite",
     "WebSearch", "TaskStop", "AskUserQuestion", "Skill", "EnterPlanMode",
     "ToolSearch"],
    mcp_servers: [
      %{name: "claude.ai Google Calendar", status: "needs-auth"},
      %{name: "claude.ai Gmail", status: "needs-auth"}
    ],
    model: "claude-opus-4-5-20251101",
    permission_mode: "default",
    slash_commands: ["compact", "context", "cost", "init", "pr-comments",
     "release-notes", "review", "security-review"],
    api_key_source: "none",
    claude_code_version: "2.1.19",
    output_style: "default",
    agents: ["Bash", "general-purpose", "statusline-setup", "Explore", "Plan"],
    skills: [],
    plugins: []
  }
}
%CeCe.Message{
  type: :assistant,
  session_id: "bd8c53c0-82a8-4421-9fbd-64fc39be1502",
  uuid: "6146b483-0b97-458b-b4a5-f85a0a11de1e",
  parent_tool_use_id: :null,
  payload: %CeCe.Payload.Assistant{
    model: "claude-opus-4-5-20251101",
    message_id: "msg_01A4nHQav6EdCKGTa9os3yVv",
    content: [
      %CeCe.Content.Text{
        text: "CeCe is a Claude Code Elixir client - a GenServer library that wraps the Claude Code CLI using ProtonStream for process management.\n\n**Key components:**\n\n- **`lib/ce_ce.ex`** - Main module implementing `@behaviour ProtonStream`. Provides two modes:\n  - Simple mode: `start_link(pid, opts)` - messages sent to handler PID\n  - Callback module mode: `start_link(module, init_arg, opts)` - user module implements `handle_message/2`\n\n- **`lib/ce_ce/message.ex`** - Parses JSON from CLI into `%CeCe.Message{}` structs with type (`:system`, `:assistant`, `:user`)\n\n- **`lib/ce_ce/payload/`** - Payload structs for each message type:\n  - `System` - init message with model, tools, cwd, etc.\n  - `Assistant` - Claude responses with content blocks\n  - `User` - tool results\n\n- **`lib/ce_ce/content/`** - Content block structs:\n  - `Text` - text responses\n  - `ToolUse` - tool invocations\n\n- **`lib/mix/tasks/claude.ex`** - Interactive `mix claude` task\n\n**Architecture:** CeCe wraps user state, forwarding GenServer callbacks (`handle_call`, `handle_cast`, `handle_info`, `handle_continue`, `terminate`) to the user module while handling ProtonStream callbacks (`handle_stdout`, `handle_stderr`, `handle_exit`) internally to parse JSON and deliver messages."
      }
    ],
    stop_reason: :null,
    usage: %{
      cache_creation_input_tokens: 101231,
      cache_read_input_tokens: 13686,
      input_tokens: 2,
      output_tokens: 1
    }
  }
}
```

For `handle_stderr/2`, add `@behaviour ProtonStream`.

## Options

- `:cwd` - Working directory for Claude Code (default: `File.cwd!()`)
- `:name` - GenServer name registration
- `:system_prompt` - Optional system prompt passed to Claude CLI

## Interactive Session

Run an interactive Claude Code session:

```bash
mix claude
```

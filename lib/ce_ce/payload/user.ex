defmodule CeCe.Payload.User do
  @moduledoc false

  alias CeCe.Payload.User.Message

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @required_fields [:message]

  @type t :: %__MODULE__{
          type: :user,
          session_id: String.t() | nil,
          uuid: String.t() | nil,
          parent_tool_use_id: String.t() | nil,
          timestamp: String.t() | nil,
          message: Message.t()
        }

  @derive JSON.Encoder
  defstruct @required_fields ++ [:session_id, :uuid, :parent_tool_use_id, :timestamp, type: :user]

  @doc """
  Builds an outbound user message envelope wrapping `content` (a string, or a
  list of content blocks). A fresh `uuid` and an ISO-8601 `timestamp` are
  generated; any field can be overridden via `opts` (e.g. `:session_id`).
  """
  @spec new(String.t() | [Message.content()], keyword()) :: t()
  def new(content, opts \\ []) do
    defaults = [
      uuid: UUID.uuid4(),
      timestamp: DateTime.to_iso8601(DateTime.utc_now()),
      message: %Message{content: content}
    ]

    struct!(__MODULE__, Keyword.merge(defaults, opts))
  end

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    %__MODULE__{
      session_id: Map.get(json, "session_id"),
      uuid: Map.get(json, "uuid"),
      parent_tool_use_id: Map.get(json, "parent_tool_use_id"),
      timestamp: Map.get(json, "timestamp"),
      message: json |> Map.fetch!("message") |> Message.parse()
    }
  end
end

defmodule CeCe.Content.RateLimitInfo do
  @moduledoc """
  Rate limit information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: String.t(),
          retryAfter: integer() | nil,
          message: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:type, :retryAfter, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # Optional: retryAfter, message
    %__MODULE__{
      type: Map.fetch!(json, "type"),
      retryAfter: Map.get(json, "retryAfter"),
      message: Map.get(json, "message")
    }
  end
end

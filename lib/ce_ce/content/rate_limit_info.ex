defmodule CeCe.Content.RateLimitInfo do
  @moduledoc """
  Rate limit information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          type: String.t(),
          retry_after: integer() | nil,
          message: String.t() | nil
        }

  defstruct [:type, :retry_after, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      type: json["type"],
      retry_after: json["retry_after"] || json["retryAfter"],
      message: json["message"]
    }
  end
end

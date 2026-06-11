defmodule CeCe.Payload.Outbound.RateLimitEvent do
  @moduledoc """
  Rate limiting event message.

  Reports rate limiting status.
  """

  alias CeCe.Content.RateLimitInfo

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          rateLimit: RateLimitInfo.t()
        }

  @derive JSON.Encoder
  defstruct [:rateLimit]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      rateLimit: RateLimitInfo.parse(Map.fetch!(json, "rateLimit"))
    }
  end
end

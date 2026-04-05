defmodule CeCe.Payload.Outbound.RateLimitEvent do
  @moduledoc """
  Rate limiting event message.

  Reports rate limiting status.
  """

  alias CeCe.Content.RateLimitInfo

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          rate_limit: RateLimitInfo.t()
        }

  defstruct [:rate_limit]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      rate_limit: RateLimitInfo.parse(json["rate_limit"] || json["rateLimit"] || json)
    }
  end
end

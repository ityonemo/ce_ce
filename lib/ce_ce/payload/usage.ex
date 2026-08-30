defmodule CeCe.Payload.Usage do
  @moduledoc """
  Token usage reported on assistant and result messages.

  All known top-level keys are enumerated as typed fields; the two nested objects
  (`server_tool_use`, `cache_creation`) are kept as raw maps. `parse/1` **raises**
  on any unknown top-level key, so a new Anthropic usage field surfaces loudly
  (as a crash) rather than being silently dropped or breaking the JSON round-trip.
  """

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          input_tokens: non_neg_integer() | nil,
          output_tokens: non_neg_integer() | nil,
          cache_creation_input_tokens: non_neg_integer() | nil,
          cache_read_input_tokens: non_neg_integer() | nil,
          server_tool_use: %{optional(String.t()) => json()} | nil,
          service_tier: String.t() | nil,
          cache_creation: %{optional(String.t()) => json()} | nil,
          output_tokens_details: %{optional(String.t()) => json()} | nil,
          inference_geo: json() | nil,
          iterations: json() | nil,
          speed: json() | nil
        }

  @derive JSON.Encoder
  defstruct [
    :input_tokens,
    :output_tokens,
    :cache_creation_input_tokens,
    :cache_read_input_tokens,
    :server_tool_use,
    :service_tier,
    :cache_creation,
    :output_tokens_details,
    :inference_geo,
    :iterations,
    :speed
  ]

  @known_keys ~w[
    input_tokens output_tokens cache_creation_input_tokens cache_read_input_tokens
    server_tool_use service_tier cache_creation output_tokens_details
    inference_geo iterations speed
  ]

  @spec parse(%{String.t() => json()}) :: t()
  def parse(json) do
    if unknown = Enum.find(Map.keys(json), &(&1 not in @known_keys)) do
      raise ArgumentError,
            "unknown usage field #{inspect(unknown)} — add it to CeCe.Payload.Usage"
    end

    %__MODULE__{
      input_tokens: Map.get(json, "input_tokens"),
      output_tokens: Map.get(json, "output_tokens"),
      cache_creation_input_tokens: Map.get(json, "cache_creation_input_tokens"),
      cache_read_input_tokens: Map.get(json, "cache_read_input_tokens"),
      server_tool_use: Map.get(json, "server_tool_use"),
      service_tier: Map.get(json, "service_tier"),
      cache_creation: Map.get(json, "cache_creation"),
      output_tokens_details: Map.get(json, "output_tokens_details"),
      inference_geo: Map.get(json, "inference_geo"),
      iterations: Map.get(json, "iterations"),
      speed: Map.get(json, "speed")
    }
  end
end

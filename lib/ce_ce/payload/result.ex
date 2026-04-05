defmodule CeCe.Payload.Result do
  @moduledoc """
  Result payload, sent when Claude completes a turn.

  Contains completion status and any permission denials.
  """

  @behaviour Access

  @type t :: %__MODULE__{
          subtype: :success | :error | atom(),
          cost_usd: float() | nil,
          duration_ms: integer() | nil,
          duration_api_ms: integer() | nil,
          is_error: boolean(),
          num_turns: integer() | nil,
          session_id: String.t() | nil,
          total_cost_usd: float() | nil,
          permission_denials: list()
        }

  defstruct [
    :subtype,
    :cost_usd,
    :duration_ms,
    :duration_api_ms,
    :is_error,
    :num_turns,
    :session_id,
    :total_cost_usd,
    :permission_denials
  ]

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(_, _, _), do: raise("CeCe.Payload.Result is read-only")

  @impl Access
  def pop(_, _), do: raise("CeCe.Payload.Result is read-only")

  def parse(json) do
    %__MODULE__{
      subtype: parse_subtype(json["subtype"]),
      cost_usd: json["cost_usd"],
      duration_ms: json["duration_ms"],
      duration_api_ms: json["duration_api_ms"],
      is_error: json["is_error"] || false,
      num_turns: json["num_turns"],
      session_id: json["session_id"],
      total_cost_usd: json["total_cost_usd"],
      permission_denials: json["permission_denials"] || []
    }
  end

  defp parse_subtype("success"), do: :success
  defp parse_subtype("error"), do: :error
  defp parse_subtype(nil), do: :success
  defp parse_subtype(other), do: String.to_atom(other)
end

defmodule CeCe.Payload.Outbound.Result do
  @moduledoc """
  Result payload, sent when Claude completes a turn.

  Contains completion status, usage information, and any permission denials.
  """

  alias CeCe.Content.Usage
  alias CeCe.Content.ModelUsage
  alias CeCe.Content.PermissionDenial

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          subtype: :success | :error | atom(),
          cost_usd: float() | nil,
          duration_ms: integer() | nil,
          duration_api_ms: integer() | nil,
          is_error: boolean(),
          num_turns: integer() | nil,
          session_id: String.t() | nil,
          total_cost_usd: float() | nil,
          permission_denials: [PermissionDenial.t()],
          usage: Usage.t() | nil,
          model_usage: [ModelUsage.t()],
          stop_reason: String.t() | nil,
          result: map() | nil,
          structured_output: map() | nil
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
    :permission_denials,
    :usage,
    :model_usage,
    :stop_reason,
    :result,
    :structured_output
  ]

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
      permission_denials: PermissionDenial.parse_list(json["permission_denials"]),
      usage: Usage.parse(json["usage"]),
      model_usage: ModelUsage.parse_list(json["model_usage"]),
      stop_reason: json["stop_reason"] || json["stopReason"],
      result: json["result"],
      structured_output: json["structured_output"] || json["structuredOutput"]
    }
  end

  defp parse_subtype("success"), do: :success
  defp parse_subtype("error"), do: :error
  defp parse_subtype(nil), do: :success
  defp parse_subtype(other), do: String.to_atom(other)
end

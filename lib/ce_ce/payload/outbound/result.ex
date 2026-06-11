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
          costUsd: float() | nil,
          durationMs: integer() | nil,
          durationApiMs: integer() | nil,
          isError: boolean(),
          numTurns: integer() | nil,
          sessionId: String.t() | nil,
          totalCostUsd: float() | nil,
          permissionDenials: [PermissionDenial.t()],
          usage: Usage.t() | nil,
          modelUsage: [ModelUsage.t()],
          stopReason: String.t() | nil,
          result: map() | nil,
          structuredOutput: map() | nil
        }

  @derive JSON.Encoder
  defstruct [
    :subtype,
    :costUsd,
    :durationMs,
    :durationApiMs,
    :isError,
    :numTurns,
    :sessionId,
    :totalCostUsd,
    :permissionDenials,
    :usage,
    :modelUsage,
    :stopReason,
    :result,
    :structuredOutput
  ]

  @subtypes ~w[success error]a
  @subtype_map Map.new(@subtypes, &{"#{&1}", &1})

  def parse(json) do
    # Optional: subtype (defaults to success), costUsd, durationMs, durationApiMs,
    #           isError (defaults to false), numTurns, sessionId, totalCostUsd,
    #           permissionDenials, usage, modelUsage, stopReason, result, structuredOutput
    %__MODULE__{
      subtype: parse_subtype(Map.get(json, "subtype")),
      costUsd: Map.get(json, "costUsd"),
      durationMs: Map.get(json, "durationMs"),
      durationApiMs: Map.get(json, "durationApiMs"),
      isError: Map.get(json, "isError", false),
      numTurns: Map.get(json, "numTurns"),
      sessionId: Map.get(json, "sessionId"),
      totalCostUsd: Map.get(json, "totalCostUsd"),
      permissionDenials: PermissionDenial.parse_list(Map.get(json, "permissionDenials")),
      usage: Usage.parse(Map.get(json, "usage")),
      modelUsage: ModelUsage.parse_list(Map.get(json, "modelUsage")),
      stopReason: Map.get(json, "stopReason"),
      result: Map.get(json, "result"),
      structuredOutput: Map.get(json, "structuredOutput")
    }
  end

  defp parse_subtype(nil), do: :success
  defp parse_subtype(subtype), do: Map.fetch!(@subtype_map, subtype)
end

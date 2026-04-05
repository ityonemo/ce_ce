defmodule CeCe.Test.RoundTrip do
  @moduledoc """
  Helper functions for round-trip JSON encode/decode tests.
  """

  import ExUnit.Assertions

  @doc """
  Assert that specified fields survive the JSON round-trip.

  Takes a JSON string, decodes it, parses it into a struct using the given module,
  encodes it back to JSON, and verifies the expected fields match.
  """
  def assert_round_trip(json_string, module, expected_fields) do
    decoded = JSON.decode!(json_string)
    struct = module.parse(decoded)
    encoded = JSON.encode!(struct) |> JSON.decode!()

    for field <- expected_fields do
      assert Map.has_key?(encoded, field),
             "Expected field #{inspect(field)} in encoded output, got: #{inspect(Map.keys(encoded))}"

      expected_value = Map.get(decoded, field)
      actual_value = Map.get(encoded, field)

      assert actual_value == expected_value,
             "Field #{inspect(field)} mismatch:\n  expected: #{inspect(expected_value)}\n  actual: #{inspect(actual_value)}"
    end

    {decoded, struct, encoded}
  end
end

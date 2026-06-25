defmodule CeCe.Test.RoundTrip do
  @moduledoc """
  Helper functions for round-trip JSON encode/decode tests.
  """

  import ExUnit.Assertions

  alias CeCe.Payload

  @doc """
  Assert that specified fields survive the JSON round-trip.

  Takes a JSON string, decodes it, parses it into a struct using the given module,
  encodes it back to JSON, and verifies the expected fields match.
  """
  def assert_round_trip(json_string, reified) do
    decoded = JSON.decode!(json_string)
    assert reified == Payload.parse(decoded)
    assert decoded == reified |> JSON.encode!() |> JSON.decode!()
  end
end

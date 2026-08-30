defmodule CeCe.Messages.Outbound.UsageTest do
  use ExUnit.Case

  alias CeCe.Payload.Usage

  describe "parse/1" do
    test "reifies the full live usage shape" do
      json = %{
        "input_tokens" => 100,
        "output_tokens" => 50,
        "cache_creation_input_tokens" => 0,
        "cache_read_input_tokens" => 0,
        "server_tool_use" => %{"web_search_requests" => 0, "web_fetch_requests" => 0},
        "service_tier" => nil,
        "cache_creation" => %{
          "ephemeral_1h_input_tokens" => 0,
          "ephemeral_5m_input_tokens" => 0
        },
        "inference_geo" => nil,
        "iterations" => nil,
        "speed" => nil
      }

      assert %Usage{
               input_tokens: 100,
               output_tokens: 50,
               cache_creation_input_tokens: 0,
               cache_read_input_tokens: 0,
               server_tool_use: %{"web_search_requests" => 0, "web_fetch_requests" => 0},
               service_tier: nil,
               cache_creation: %{"ephemeral_1h_input_tokens" => 0},
               inference_geo: nil,
               iterations: nil,
               speed: nil
             } = Usage.parse(json)
    end

    test "handles a minimal usage object (only the token fields)" do
      json = %{"input_tokens" => 500, "output_tokens" => 200}

      assert %Usage{input_tokens: 500, output_tokens: 200, service_tier: nil} =
               Usage.parse(json)
    end

    test "crashes on an unknown top-level key so a new Anthropic field is not silently dropped" do
      assert_raise ArgumentError, fn ->
        Usage.parse(%{"input_tokens" => 1, "brand_new_field" => 9})
      end
    end
  end

  describe "JSON round-trip" do
    test "encodes back to the same JSON" do
      json =
        JSON.decode!(~s|{
          "input_tokens": 100,
          "output_tokens": 50,
          "cache_creation_input_tokens": null,
          "cache_read_input_tokens": null,
          "server_tool_use": null,
          "service_tier": "standard",
          "cache_creation": null,
          "inference_geo": null,
          "iterations": null,
          "speed": null
        }|)

      assert json == json |> Usage.parse() |> JSON.encode!() |> JSON.decode!()
    end
  end
end

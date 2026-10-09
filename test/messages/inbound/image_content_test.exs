defmodule CeCe.Messages.Inbound.ImageContentTest do
  @moduledoc """
  Image content blocks arrive in two shapes.

  MCP tools emit `data` and `mimeType` at the top level. Claude Code emits the
  Anthropic API shape, nesting them under `source` as `data` and `media_type` —
  which is what a screenshot tool result looks like. Both must parse, and each
  must round-trip back to the shape it arrived in.
  """
  use ExUnit.Case

  import CeCe.Test.RoundTrip

  alias CeCe.Payload
  alias CeCe.Payload.Common.ImageContent
  alias CeCe.Payload.User
  alias CeCe.Payload.User.Message
  alias CeCe.Payload.User.ToolResultContent

  describe "the MCP shape" do
    test "parses data and mimeType from the top level" do
      json = ~s|{"type": "image", "data": "aGk=", "mimeType": "image/png"}|

      assert %ImageContent{data: "aGk=", mimeType: "image/png"} =
               json |> JSON.decode!() |> ImageContent.parse()
    end
  end

  describe "the Anthropic source shape" do
    test "parses data and media_type from source" do
      json = ~s|{
        "type": "image",
        "source": {"type": "base64", "media_type": "image/png", "data": "aGk="}
      }|

      assert %ImageContent{data: "aGk=", mimeType: "image/png"} =
               json |> JSON.decode!() |> ImageContent.parse()
    end

    test "round-trips back as a source block, not a flattened one" do
      json = ~s|{
        "type": "image",
        "source": {"type": "base64", "media_type": "image/png", "data": "aGk="}
      }|

      decoded = JSON.decode!(json)
      reencoded = decoded |> ImageContent.parse() |> JSON.encode!() |> JSON.decode!()

      assert reencoded == decoded
    end
  end

  describe "a tool_result carrying a screenshot" do
    test "round-trips the whole user message" do
      # The shape that crashed a conversation: a tool returning an image, which
      # could not be loaded back out of storage.
      json = ~s|{
        "type": "user",
        "session_id": "abc-123",
        "uuid": "def-456",
        "parent_tool_use_id": null,
        "timestamp": null,
        "message": {
          "role": "user",
          "content": [
            {
              "tool_use_id": "toolu_123",
              "type": "tool_result",
              "content": [
                {
                  "type": "image",
                  "source": {"type": "base64", "media_type": "image/png", "data": "aGk="}
                }
              ]
            }
          ]
        }
      }|

      assert_round_trip(json, %User{
        session_id: "abc-123",
        uuid: "def-456",
        parent_tool_use_id: nil,
        timestamp: nil,
        message: %Message{
          role: :user,
          content: [
            %ToolResultContent{
              tool_use_id: "toolu_123",
              content: [
                %ImageContent{
                  data: "aGk=",
                  mimeType: "image/png",
                  extra: %{"source" => %{"type" => "base64"}}
                }
              ]
            }
          ]
        }
      })
    end

    test "parsing does not raise on the source shape" do
      json = ~s|{
        "type": "user",
        "session_id": "s",
        "message": {
          "role": "user",
          "content": [
            {
              "tool_use_id": "t",
              "type": "tool_result",
              "content": [
                {
                  "type": "image",
                  "source": {"type": "base64", "media_type": "image/png", "data": "aGk="}
                }
              ]
            }
          ]
        }
      }|

      assert %User{} = json |> JSON.decode!() |> Payload.parse()
    end
  end
end

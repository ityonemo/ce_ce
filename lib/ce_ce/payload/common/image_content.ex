defmodule CeCe.Payload.Common.ImageContent do
  @moduledoc false

  use CeCe.Payload

  @type json :: CeCe.Payload.json()

  @type t :: %__MODULE__{
          type: :image,
          data: String.t(),
          mimeType: String.t(),
          extra: %{optional(String.t()) => json()}
        }

  defstruct type: :image, data: nil, mimeType: nil, extra: %{}

  # An image block arrives in one of two shapes. MCP tools put `data` and
  # `mimeType` at the top level; Claude Code sends the Anthropic API shape,
  # nesting them under `source` as `data` and `media_type` — which is what a
  # screenshot tool result looks like.
  #
  # Both load into the same struct. Which shape it arrived in is remembered in
  # `extra`, so re-encoding returns what was received rather than silently
  # rewriting one format into the other.
  @spec parse(%{String.t() => json()}) :: t()
  def parse(%{"source" => %{} = source} = json) do
    %__MODULE__{
      data: Map.fetch!(source, "data"),
      mimeType: Map.fetch!(source, "media_type"),
      extra:
        json
        |> Map.drop(["type", "source"])
        |> Map.put("source", Map.drop(source, ["data", "media_type"]))
    }
  end

  def parse(json) do
    %__MODULE__{
      data: Map.fetch!(json, "data"),
      mimeType: Map.fetch!(json, "mimeType"),
      extra: Map.drop(json, ["type", "data", "mimeType"])
    }
  end

  defimpl JSON.Encoder do
    alias CeCe.Payload.Common.ImageContent

    # Re-emit the shape this block arrived in: a "source" key in `extra` marks
    # it as the Anthropic form, so data and media_type go back inside it.
    def encode(%ImageContent{extra: %{"source" => source}} = block, encoder) do
      %{
        "type" => "image",
        "source" => Map.merge(source, %{"data" => block.data, "media_type" => block.mimeType})
      }
      |> Map.merge(Map.drop(block.extra, ["source"]))
      |> JSON.Encoder.encode(encoder)
    end

    def encode(block, encoder), do: CeCe.Payload._encode_json_merging(block, :extra, encoder)
  end
end

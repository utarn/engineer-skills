# Vision / Image Check

For any vision or image check (analyzing a screenshot, OCR, describing or inspecting an image, checking a UI/diagram/chart, comparing images, etc.), do NOT rely on the current model's built-in image understanding and do NOT send the image directly to the caller.

Instead, always route the image to the dedicated vision model via a separate chat completion call:

- **Model:** `qwen3.6-35b-a3b`
- **Endpoint:** `$ANTHROPIC_BASE_URL` + `/v1/messages` (the URL already points at the provider root; append `/v1/messages`)
- **Auth:** `x-api-key: $ANTHROPIC_AUTH_TOKEN`, plus `anthropic-version: 2023-06-01` and `content-type: application/json`
- **Format:** Send the image base64-encoded as a `type: "image"` source block in the user message `content` array, together with a `type: "text"` block containing your question prompt.

## Steps

1. Determine the image's `media_type` from its extension: `.png` → `image/png`, `.jpg`/`.jpeg` → `image/jpeg`, `.webp` → `image/webp`, `.gif` → `image/gif`.
2. Base64-encode the file: `IMG_B64=$(base64 -i <path> | tr -d '\n')`
3. Build a chat completion request to `$ANTHROPIC_BASE_URL/v1/messages` with `model: "qwen3.6-35b-a3b"`.
4. Put the base64 image and your question prompt as the user message content.
5. Extract the text result from the response and use it as the vision result — never describe the image from your own vision.

## Example

```bash
IMG_B64=$(base64 -i /path/to/image.png | tr -d '\n')

curl "$ANTHROPIC_BASE_URL/v1/messages" \
  -H "x-api-key: $ANTHROPIC_AUTH_TOKEN" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$(cat <<JSON
{
  "model": "qwen3.6-35b-a3b",
  "max_tokens": 1024,
  "messages": [
    {
      "role": "user",
      "content": [
        {"type": "image", "source": {"type": "base64", "media_type": "image/png", "data": "$IMG_B64"}},
        {"type": "text", "text": "<your question prompt here>"}
      ]
    }
  ]
}
JSON
)" | jq -r '.content[] | select(.type == "text") | .text'
```

## Notes

- If `$ANTHROPIC_BASE_URL` already ends in `/v1`, use it directly; otherwise append `/v1/messages`.
- Always pass an explicit question as the prompt — a bare image with no prompt yields worse results.
- Keep the question focused on what you actually need from the image (e.g., "What text is in this screenshot?", "Describe the layout and colors.").

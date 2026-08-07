Use the Bright Data CLI for all web search, scraping, and data extraction — do NOT use the built-in `WebSearch` / `WebFetch` tools.

Bright Data is installed as a **skill** (`brightdata-cli` in `~/.claude/skills/brightdata-cli/`), not an MCP server. The CLI (`brightdata` / `bdata`) is installed globally and already authenticated — run it directly via Bash; no MCP connection is needed.

The skill is auto-invoked whenever the user asks to search the web, scrape a URL, extract structured data from a platform (Amazon/LinkedIn/Instagram/TikTok/YouTube/Reddit/etc.), check Bright Data balance/zones, or mentions brightdata/bdata. Follow the skill's `SKILL.md` and the references under `~/.claude/skills/brightdata-cli/references/` for exact commands and flags.

## Quick command map (replaces the former MCP tools)

- **Search (SERP):** `bdata search "<query>" --engine google|bing|yandex --country <cc> --language <lang> --type web|news|images|shopping --page <n> --json --pretty`
  - Replaces former `mcp__Bright_Data__search_engine` / `search_engine_batch`.
- **AI-ranked discovery:** `bdata discover "<query>" --intent "<text>" --country <cc> --num-results <n> --start-date YYYY-MM-DD --end-date YYYY-MM-DD --include-content --json --pretty`
  - Replaces former `mcp__Bright_Data__discover`. Use for intent ranking and date filtering.
- **Scrape a page:** `bdata scrape <url> --format markdown|html|json|screenshot --country <cc> --mobile --json --pretty`
  - Replaces former `mcp__Bright_Data__scrape_as_markdown` / `scrape_batch`. Unlocks pages behind bot detection / CAPTCHA.
- **Structured data (40+ platforms):** `bdata pipelines <type> [params]` — run `bdata pipelines list` for types.
- **Account / zones:** `bdata budget`, `bdata zones`.

## Steps

1. Search/discover with `bdata search` (or `bdata discover` for date-filtered / intent-ranked queries). Use the user's full question as the query — specific queries return better results.
2. Pick the 1–5 most relevant result URLs from the JSON output.
3. Read them with `bdata scrape <url> --format markdown` (one URL) — or loop over a few URLs.
4. Answer using the fetched content. End with a "Sources:" list of the URLs you used as markdown links.

## Notes

- Do NOT call the built-in `WebSearch` tool — use the Bright Data CLI above instead.
- For library/framework/SDK/API documentation specifically, prefer the `ctx7` CLI rule over web search.
- If the CLI errors on auth, re-run `bdata login` (or `bdata login --api-key <key>` non-interactively). For headless/SSH use `bdata login --device`.
- For one-off use without the global install: `npx --yes --package @brightdata/cli brightdata <command>`.
- Batch scraping (former `scrape_batch`): run multiple `bdata scrape` calls, or use `bdata scrape --async` + `bdata status <job-id>` for large jobs.

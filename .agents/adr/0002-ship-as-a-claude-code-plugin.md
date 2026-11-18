# Ship the skill set as a native Claude Code plugin; defer a native Codex plugin

These skills have always been installable via [skills.sh](https://skills.sh/utarn/engineer-skills) (`npx skills add utarn/engineer-skills`), which copies editable skill files into a user's project across Claude Code, Codex, and other Agent-Skills-standard harnesses. A recurring request is a **plug-and-play** distribution: subscribe to the set as a read-only, always-current bundle you don't edit, rather than a fork you own. That is exactly what native plugin systems provide.

We ship a native **Claude Code plugin** and, for now, **defer** a native **Codex plugin**. The split is forced by how each ecosystem's plugin manifest selects skills, against this repo's bucketed layout.

## The constraint: bucketed skills vs. single-path selection

Skills live in bucket folders under `skills/`: `engineering/` and `productivity/` are **promoted** (shipped); `misc/`, `personal/`, `in-progress/`, and `deprecated/` are **not**. A plugin must expose only the promoted set, which spans two of those bucket folders.

- **Claude Code**: `.claude-plugin/plugin.json` accepts `skills` as an **array of explicit skill-directory paths**. We list the promoted skills one by one, exclude everything else with zero ambiguity, and add `.claude-plugin/marketplace.json` so the repo is its own single-plugin marketplace. Verified end to end: `claude plugin validate . --strict` passes, and `marketplace add` → `install` resolves all promoted skills.

- **Codex**: `.codex-plugin/plugin.json` accepts `skills` only as a **single path string** (arrays are rejected with `missing or invalid plugin.json`), and Codex discovers `SKILL.md` files recursively under it. There is no way to name two bucket folders, or to curate a subset, from one path. Two escape hatches were tested and rejected:
  - Pointing at `./skills/` would also ship `deprecated/`, `in-progress/`, `personal/`, and `misc/`: retired, draft, and personal skills we deliberately don't promote.
  - A curated flat directory of **symlinks** into the buckets does not survive install: Codex copies the plugin tree into its cache and **drops symlinks**, so the skills arrive empty.

The only robust ways to give Codex a single promoted-only path are (a) **restructure** so `skills/` contains only promoted skills (moving the non-promoted buckets out, a large blast radius across `CLAUDE.md`, `scripts/link-skills.sh`, the bucket READMEs, and the local dev workflow that relies on `in-progress/` and `personal/`), or (b) **commit duplicate copies** of promoted skills into a flat directory (a sync burden and a second source of truth). Both are structural decisions, not something to bundle into shipping the Claude plugin. This is very likely the original, half-remembered reason a plugin wasn't shipped earlier: the manifest formats didn't cleanly express a curated subset of a bucketed repo.

## Decision

- Ship the **Claude Code plugin** now (`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`), curated to the promoted set, as the headline v1.2 deliverable.
- Keep **skills.sh** as the universal installer: it already serves Codex and other harnesses today, so no Codex user is left without an install path.
- **Defer** the native Codex plugin until we decide between restructuring `skills/` to promoted-only vs. committing a generated flat copy. Revisit when Codex either supports a `skills` array / include-list or preserves symlinks on install.

## Invariants this creates

- Every promoted skill has an entry in `.claude-plugin/plugin.json`'s `skills` array (this already stood as a `CLAUDE.md` rule; it now also gates the plugin's contents).
- `.claude-plugin/plugin.json`'s `version` tracks `package.json`'s version: bump both together on release. Claude uses the plugin `version` to decide when installed users see an update.

## Update, 2026-10-07

The Codex constraint above no longer holds. Codex `main` accepts a `skills` string array and falls back to `.claude-plugin/` when there is no `.codex-plugin/` ([manifest.rs](https://github.com/openai/codex/blob/main/codex-rs/core-plugins/src/manifest.rs)). Codex still drops symlinks.

On Codex 0.161.0, the `@utarn` marketplace install loads the promoted model-invoked skills and nothing from `misc/` or `in-progress/`. Copilot CLI reads the same manifests and reports "Installed 37 skills".

## Update, 2026-10-08: managed installs first

`@utarn` is now the lead route on Codex, Copilot and VS Code, at the cost of a one-time opt-in on Copilot. Claude Code installs from this fork's own marketplace, because the fork is not listed in `claude-plugins-official`.

The version invariant above now applies to every managed route. `npm run version` already keeps it by running `scripts/sync-plugin-version.mjs`. `marketplace.json` has no `version` field, so it can't drift.

## Update, 2026-11-18: this fork ships its own marketplace

The official-marketplace route described upstream does not apply to this fork. `utarn-skills` is not listed in `claude-plugins-official`; it installs from this repo's own single-plugin marketplace instead:

```bash
claude plugin marketplace add utarn/engineer-skills
claude plugin install utarn-skills@utarn
```

The marketplace points at this repo's git URL and reads `.claude-plugin/plugin.json` directly. Installed users see an update when `.claude-plugin/plugin.json`'s `version` changes, so a release requires bumping it alongside `package.json`.

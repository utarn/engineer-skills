---
name: setup-utarn-skills-yes
description: "Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills. Takes every recommended default without a confirmation round."
disable-model-invocation: true
---

# Setup Utarn Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker**: where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels**: the strings used for the five canonical triage roles
- **Domain docs**: where `GLOSSARY.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, take the recommended default for every section, derived from what the repo itself implies, then write. There are no confirmation rounds.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config`: is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root: does either exist? Is there already an `## Agent skills` section in either?
- `GLOSSARY.md` and `GLOSSARY-MAP.md` at the repo root, and the legacy `CONTEXT.md` / `CONTEXT-MAP.md`. If a legacy file exists, `git mv` it to its `GLOSSARY` name and rewrite those names in `docs/agents/domain.md`.
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/`: does this skill's prior output already exist?
- `.scratch/`: a sign that a local-markdown issue tracker convention is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals: a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. These are present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.

### 2. Present findings and take the defaults

Summarise what's present and what's missing, then take each section's recommended default without asking. Show each choice in one line as you make it, so the final state is auditable. Skip a section entirely when exploration already settled it (Section B when `triage` isn't installed).

**Section A: Issue tracker.** Take the default the remote implies:

- A `git remote` pointing at GitHub → **GitHub** (issues live in the repo's GitHub Issues, via the `gh` CLI)
- A `git remote` pointing at GitLab (`gitlab.com` or a self-hosted host) → **GitLab** (via the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- Anything else → **local markdown** (issues live as files under `.scratch/<feature>/` in this repo)

Custom trackers (Jira, Linear, …) need a workflow description only the user can give, so they are out of reach here; run the interactive `/setup-utarn-skills` for those.

Record the choice in `docs/agents/issue-tracker.md`. The GitHub and GitLab templates carry a "PRs as a request surface" flag, defaulted **off**; leave it off. A user who wants external PRs in the triage queue can flip the flag in the file later.

A GitHub or GitLab tracker needs a reachable repo. When the remote points at one and no `git remote` points at that host, wire it up only if the repo URL is already discoverable (`git init` if needed, `git remote add origin <url>`). Done when `gh repo view` / `glab repo view` prints the project from inside this directory; if it can't, stop and tell the user what's missing rather than picking a tracker the repo cannot reach.

**Section B: Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you), since an uninstalled skill needs no labels.

If it is installed, take the default: keep the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Write them as-is. Only a tracker that already uses other names (e.g. `bug:triage` for `needs-triage`) needs overrides, and that needs the interactive `/setup-utarn-skills`.

**Section C: Domain docs.** Take the default the repo shape implies: **single-context** (one `GLOSSARY.md` + `docs/adr/` at the repo root) unless exploration found monorepo signals, in which case **multi-context** (a root `GLOSSARY-MAP.md` pointing to per-context `GLOSSARY.md` files). Write it without asking.

### 3. Draft

Draft, without waiting for edits, step 5 reports everything that was chosen:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, create `CLAUDE.md`.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa); always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout: "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted.

When Section B ran on GitHub or GitLab, create each configured label the tracker lacks (`gh label create` / `glab label create`).

Then write the docs files using the seed templates in the `setup-utarn-skills` folder as a starting point:

- [issue-tracker-github.md](../setup-utarn-skills/issue-tracker-github.md): GitHub issue tracker
- [issue-tracker-gitlab.md](../setup-utarn-skills/issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](../setup-utarn-skills/issue-tracker-local.md): local-markdown issue tracker
- [triage-labels.md](../setup-utarn-skills/triage-labels.md): label mapping (only if `triage` is installed)
- [domain.md](../setup-utarn-skills/domain.md): domain doc consumer rules + layout

### 5. Done

Tell the user the setup is complete and recap the defaults that were taken: tracker, triage labels, doc layout, and which file was edited. Then name which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later, and that a default that turned out wrong can be fixed by editing the file or re-running the interactive `/setup-utarn-skills`; re-running is otherwise only necessary to switch issue trackers or restart from scratch.

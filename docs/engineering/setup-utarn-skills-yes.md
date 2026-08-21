## What it does

`setup-utarn-skills-yes` configures a repo for the engineering skills — issue tracker, triage label vocabulary, domain doc layout — into `docs/agents/` files exactly as [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) does, but it accepts the recommended default for every section and writes without a confirmation round.

The defining constraint is that every default is derived from the repo itself, not asked of you: the `git remote` decides the tracker, the installed `triage` skill gets the canonical labels, and the repo's shape decides the doc layout. It still explores first — that is what makes the defaults suitable rather than blind — and the completion summary recaps what was taken, so the choices stay auditable.

## When to reach for it

You invoke this by typing `/setup-utarn-skills-yes` — the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own.

| Your situation | What to run |
| --- | --- |
| Fresh repo, and the defaults are what you'd pick anyway | `/setup-utarn-skills-yes` |
| You want a say in any of the three decisions, or your tracker is Jira/Linear/other | [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) |

## Prerequisites

It writes into the repo you run it in — the same outputs as the interactive skill: `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/triage-labels.md` (only when `triage` is installed), and an `## Agent skills` block in whichever of `CLAUDE.md` / `AGENTS.md` it picks.

## The defaults it takes

| Decision | Default taken |
| --- | --- |
| **Issue tracker** | remote on GitHub → GitHub; on GitLab → GitLab; anything else → local markdown under `.scratch/<feature>/` |
| **Triage labels** | the five canonical names, written as-is — and the section is skipped entirely when `triage` isn't installed |
| **Domain docs** | single-context (`CONTEXT.md` + `docs/adr/` at the root); multi-context only when monorepo signals are found |
| **Instruction file** | whichever of `CLAUDE.md` / `AGENTS.md` already exists; `CLAUDE.md` if neither |

Custom trackers (Jira, Linear, Azure DevOps) need a paragraph of workflow description only you can write, so they are out of reach here by design — run the interactive [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) for those.

## Common questions

**A default turned out wrong. Do I re-run?**
No — edit the file. The outputs are plain markdown under `docs/agents/`, and a one-line edit is cheaper than any re-run. `triage-labels.md` in particular is a mapping, so renaming a label to match your tracker's existing strings is a hand edit. Re-running is for switching trackers or starting from scratch; if you want different *answers* rather than different files, the interactive skill is the one that asks.

**It created `CLAUDE.md`, but I'm on Codex.**
The file rule matches the interactive skill's preference order — edit whichever of `CLAUDE.md` / `AGENTS.md` exists, and pick `CLAUDE.md` when neither does, rather than asking you. If your [harness](https://www.aihero.dev/ai-coding-dictionary/harness) reads `AGENTS.md`, create that file first (even a one-line pointer) and the variant will edit it instead.

## It's working if

- It runs start to finish without a single confirmation prompt — exploration, one-line choices, files written.
- The defaults match the repo: the tracker follows the remote, the labels are the five canonical strings, the layout matches the repo's shape.
- The outputs are identical in shape to an interactive run: the three `docs/agents/` files (two when `triage` isn't installed) and an `## Agent skills` block with no duplicate section.
- The final summary recaps every default it took — tracker, labels, layout, and which instruction file was edited.

## Where it fits

`setup-utarn-skills-yes` is the **run-once setup** for the engineering flow, sharing the role with [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) — the precondition everything else assumes rather than a step in the chain. Its readers are the same: [triage](https://aihero.dev/skills-triage) applies the label vocabulary, [to-spec](https://aihero.dev/skills-to-spec) and [to-tickets](https://aihero.dev/skills-to-tickets) publish into the tracker, and [domain-modeling](https://aihero.dev/skills-domain-modeling) fills in the doc layout later. For which skill to reach for next, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes the whole set.

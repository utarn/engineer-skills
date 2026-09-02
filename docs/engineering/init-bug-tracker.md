## What it does

`init-bug-tracker` creates — or re-syncs — the **label taxonomy** on a public GitHub bug tracker: the separate repo where users and testers file reports against a shipped product, with no source code in it. It seeds the same repo with structured issue forms — bug report and feature request, with OS and component-area dropdowns, reproduction steps, and an attachment box, blank issues disabled — plus a README explaining the tracker, then records it in the repo's `## Agent skills` config so `/bug-tracker` finds it without asking.

Four of the five label groups are identical for every project because they encode the workflow: triage and state roles, type, priority, verification. The fifth, `area:*`, describes *your* product — and that's the defining constraint: the skill derives the areas from your repo (README, directory layout, `CONTEXT.md` if you have one), and you confirm or edit the proposal, rather than the skill handing you someone else's fixed component list.

## When to reach for it

You invoke this by typing `/init-bug-tracker`, optionally with a repo (`/init-bug-tracker owner/repo`). Run it once when you open a public tracker, and again whenever the taxonomy drifts — a component was renamed, a new area appeared, a label's description went stale.

| Situation | Where to go |
| --- | --- |
| Set up or re-sync labels on a separate public report repo | `/init-bug-tracker` |
| Configure *this* repo's own tracker, label mapping, doc layout | [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) |

## Prerequisites

The `gh` CLI, authenticated (`gh auth status`), with label-management **and push** permission on the target repo — the skill creates labels and commits the issue templates. A GitHub repo to serve as the tracker — the skill drives `gh` and plain git, so other hosts aren't covered.

## Re-sync, not just bootstrap

Every label is written with `gh label create --force`, which makes the whole run idempotent: missing labels get created, existing ones get their colour and description overwritten to match the taxonomy, and nothing is deleted. That's what turns it from a bootstrap into a re-sync tool — run it any time the taxonomy drifts, on any tracker, even one another tool manages.

The fixed set: seven state roles (`needs-triage` through `resolved`, including `in-progress` and a terminal `resolved` for work awaiting reporter verification), five types, four priorities, and two verification tags. Triage's five canonical roles are a subset of the states — so running this on a tracker is also the one-shot fix when a triage flow fails with "label doesn't exist".

## Common questions

**Will it delete labels the taxonomy no longer uses?**
No. It only creates and overwrites. A retired `area:*` label stays on the repo (and on the issues that carry it) until you remove it yourself.

**Why does it write to my CLAUDE.md?**
The recording step adds a one-line `### Bug tracker` entry under the `## Agent skills` section — the same config block `setup-utarn-skills` uses — so `/bug-tracker` and later runs resolve the tracker without asking. Edit or remove the line whenever you like; the next run just asks again.

**Can I keep my own area labels?**
Yes — the derived list is a proposal, confirmed before anything is written. Hand it your own component names and it uses yours.

## It's working if

- `gh label list -R <owner/repo>` shows every planned label with the intended colour and description.
- `<tracker>/issues/new/choose` offers the bug-report and feature-request forms and no blank issue.
- The `### Bug tracker` line in `CLAUDE.md`/`AGENTS.md` names the repo.
- The next `/bug-tracker` run goes straight to fetching the queue, without asking where reports live.

## Where it fits

A **run-once setup** per tracker, paired with [bug-tracker](https://aihero.dev/skills-bug-tracker), which consumes the taxonomy it creates and the record it leaves. It sits alongside [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) — that one configures *this* repo's own tracker, this one configures the separate public one; different repos, same idea that configuration is a recorded line, not a hard-coded assumption. The map of the whole set lives at [ask-utarn](https://aihero.dev/skills-ask-utarn).

Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=to-prd
```

```bash
npx skills update to-prd
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-prd)

## What it does

`to-prd` takes the current conversation context and codebase understanding and produces a **PRD** (product requirements document), then publishes it to the project issue tracker. The defining constraint: it does **not** interview the user — it only synthesises what has already been discussed, the same no-interview discipline as [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md) but writing a PRD-shaped document for repos that use the PRD vocabulary.

It explores the repo, sketches the testing seams (preferring existing seams, highest possible, ideally one), assumes yes on the seams, then writes the PRD from the template and publishes it with the `ready-for-agent` triage label — no further triage needed.

## When to reach for it

You invoke this by typing `/to-prd` — the agent won't reach for it on its own.

Reach for it when the conversation has already settled the design and you want it captured as a PRD on the tracker without another interview round — the PRD-vocabulary sibling of [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md). Use `to-spec` for the spec-vocabulary equivalent; use [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) or [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md) afterwards to split the PRD into implementable slices.

## Prerequisites

`to-prd` publishes into your issue tracker, so [setup-utarn-skills](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/setup-utarn-skills/SKILL.md) must have configured the tracker and triage label vocabulary for this repo first. It applies the `ready-for-agent` label as it publishes.

## The no-interview synthesis

The defining idea is **synthesis, not interview**. The PRD is built only from what the conversation and codebase already hold — problem statement, solution, a long numbered list of user stories, implementation decisions, testing decisions, out-of-scope, and further notes. It avoids specific file paths or code snippets (they go stale), inlining a prototype snippet only when it encodes a decision more precisely than prose. Seam choices are assumed yes so the PRD lands without a back-and-forth.

## Where it fits

`to-prd` is a **chain step** at the head of the build flow, the PRD-vocabulary alternative to `to-spec`:

```txt
grill-with-docs → to-prd → to-issues → implement
```

Its close neighbour is [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md), the spec-vocabulary equivalent; downstream the PRD is split into slices by [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) or [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md). When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

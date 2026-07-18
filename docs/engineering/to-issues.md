Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=to-issues
```

```bash
npx skills update to-issues
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues)

## What it does

`to-issues` breaks a plan, spec, or PRD into independently-grabbable issues on the project issue tracker, each a **tracer-bullet** vertical slice that cuts end-to-end through every integration layer (schema, API, UI, tests). The defining constraint: a slice is vertical, not horizontal — a completed slice is demoable on its own, not a layer torn out in isolation.

It works from the conversation context (or a fetched issue body if you pass a reference), optionally explores the codebase for prefactor opportunities, drafts the slices, then quizzes you on granularity and dependencies before publishing. Issues go to the tracker in dependency order with the `ready-for-agent` triage label so an AFK agent can pick them up.

## When to reach for it

You invoke this by typing `/to-issues` — the agent won't reach for it on its own.

Reach for it once you have a settled plan or spec and want it split into agent-ready vertical-slice issues on a real tracker. It is the older sibling of [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md); reach for `to-tickets` when you want blocking edges expressed as native tracker links (or one-file-per-ticket locally) instead of plain issue dependencies. For the no-interview step that produces the spec or PRD first, use [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md) or [to-prd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-prd/SKILL.md).

## Prerequisites

`to-issues` publishes into your issue tracker, so [setup-utarn-skills](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/setup-utarn-skills/SKILL.md) must have configured the tracker and its triage label vocabulary for this repo first. It applies the `ready-for-agent` label as it publishes.

## The tracer-bullet slice

The defining idea is the **vertical slice**. Each issue delivers a narrow but complete path through every layer, so a finished slice is demoable or verifiable on its own — never a horizontal slab of one layer. Slices declare their blockers, are published in dependency order so the "Blocked by" field can reference real issue identifiers, and the issue body describes end-to-end behaviour (not file paths or code, which go stale) with acceptance criteria. Any prefactoring lands first: "make the change easy, then make the easy change."

## Where it fits

`to-issues` is a **chain step** that sits just after the spec/PRD is written and just before an agent picks the work up:

```txt
grill-with-docs → to-spec → to-issues → implement
```

Its close neighbour is [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md), the newer equivalent that expresses blocking edges as native tracker links; the spec it slices against comes from [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md) or [to-prd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-prd/SKILL.md). When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

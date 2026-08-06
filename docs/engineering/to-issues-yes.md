Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=to-issues-yes
```

```bash
npx skills update to-issues-yes
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues-yes)

## What it does

`to-issues-yes` is the assume-yes variant of [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md): it breaks a plan, spec, or PRD into **tracer-bullet** vertical-slice issues and publishes them straight to the project issue tracker, but instead of quizzing you on the breakdown it **assumes you approve** and proceeds. The defining constraint is the same as `to-issues` — each slice is vertical, cutting end-to-end through every integration layer, demoable on its own — with the "yes" being that it skips the approval loop.

Reach for it when the breakdown is routine enough that you trust the slices and want them on the tracker without a back-and-forth. Use [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) when you want to review and adjust the breakdown before publishing.

## When to reach for it

You invoke this by typing `/to-issues-yes` — the agent won't reach for it on its own.

Reach for it once you have a settled plan or spec and want vertical-slice issues published to the tracker without an approval round — the "yes" variant for routine breakdowns. For the interactive version where you confirm granularity and dependencies first, use [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md); for the newer edge-linked equivalent, [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md).

## Prerequisites

`to-issues-yes` publishes into your issue tracker, so [setup-utarn-skills](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/setup-utarn-skills/SKILL.md) must have configured the tracker and its triage label vocabulary for this repo first. It applies the `ready-for-agent` label as it publishes, in dependency order so "Blocked by" can reference real issue identifiers.

## The assume-yes slice

The defining idea is the **tracer-bullet vertical slice** with the approval step elided. It drafts the same end-to-end slices `to-issues` would, presents them, and proceeds to publish — trusting the breakdown. Each issue body describes end-to-end behaviour with acceptance criteria and a "Blocked by" field, never file paths or code that go stale.

## Where it fits

`to-issues-yes` is a **chain step** — the non-interactive sibling of `to-issues`, sitting between the spec and the implement loop:

```txt
grill-with-docs → to-spec → to-issues-yes → implement
```

Its closest neighbour is [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) (the interactive version) and [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md) (the newer edge-linked flow). The spec it slices against comes from [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md) or [to-prd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-prd/SKILL.md). When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

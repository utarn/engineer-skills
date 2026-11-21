## What it does

`to-tickets-yes` is the assume-yes variant of [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md): it breaks a plan, spec, or conversation into the same tracer-bullet **tickets** — each declaring its blocking edges — and publishes them to the configured tracker, but instead of quizzing you on the breakdown it **assumes you approve** and proceeds. The defining constraint is the same as `to-tickets` — every ticket is a vertical tracer bullet with blocking edges — with the "yes" being that it skips the approval loop.

Reach for it when the breakdown is routine enough that you trust the slices and want them on the tracker without a back-and-forth. Use [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md) when you want to review granularity and blocking edges before publishing.

## When to reach for it

You invoke this by typing `/to-tickets-yes` — the agent won't reach for it on its own.

Reach for it once you have an agreed plan or spec and want tracer-bullet tickets published to the tracker without an approval round — the "yes" variant for routine breakdowns. For the interactive version where you confirm granularity and edges first, use [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md); for the older issue-splitting equivalents, [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) and [to-issues-yes](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues-yes/SKILL.md).

## Prerequisites

`to-tickets-yes` publishes into your issue tracker, so [setup-utarn-skills](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/setup-utarn-skills/SKILL.md) must have configured the tracker and its triage label vocabulary for this repo first. On a real tracker it applies the `ready-for-agent` label as it publishes, in dependency order so each ticket's blocking edges can reference real identifiers.

## One artifact, two readings

The blocking edges are the whole point. They make one set of tickets read two ways, depending on the tracker:

- **Local files** → one file per ticket under `.scratch/<feature>/issues/`, numbered blockers-first, the edges written as text. You work them top-to-bottom, by hand.
- **A real tracker (GitHub, Linear)** → one issue per ticket, the edges as native blocking links (or sub-issues). Any ticket whose blockers are all done is on the **frontier** and can be grabbed — so several agents can run at once.

`to-tickets-yes` produces the same artifact as `to-tickets`; the approval loop is the only conversational difference. The behavioural one comes after publishing: it sweeps the uncommitted **planning artifacts** — `GLOSSARY.md`, ADRs, the PRD markdown, the local ticket files — into a single commit, so the implement loop starts from a clean tree instead of a working full of loose planning paper.

## The assume-yes slice

The defining idea is the **tracer-bullet vertical slice** with the approval step elided. It drafts the same edge-declaring slices `to-tickets` would, presents them, and proceeds to publish — trusting the breakdown. Each ticket describes end-to-end behaviour with acceptance criteria and a "Blocked by" field, never file paths or code that go stale. Wide refactors still get the expand–contract exception rather than being forced into a tracer bullet.

The assume-yes part is the approval step, not the sizing rule. Every slice must fit one fresh implementer [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) with headroom for the prompt, tool output, and reasoning — roughly 100K tokens of working material. A ticket that needs a long file list, many modules, or more than a handful of acceptance criteria is split vertically before publishing, with the new blocking edges wired in. The ticket count is an output of that budget, never a target; merging slices to keep the count down is how a ticket arrives too large for the context it is implemented in.

## Common questions

**Does "yes" also skip the context-size check?**
No. The "yes" removes the approval round, not the sizing rule. Every slice still has to fit one fresh implementer context window with headroom, and an over-budget draft is split before publishing. Trusting the breakdown means trusting the slices were sized, not skipping the check that made them trustworthy.

## It's working if

- Every ticket reads as a narrow end-to-end slice, not a layer or a file list.
- Each ticket's acceptance criteria fit on one screen and can be verified in one implementer run.
- Oversized drafts were split into smaller vertical slices before publishing, with blocking edges added.
- It never pauses for approval — the trace runs from breakdown to published tickets.
- The publish order respects blocking edges, so each ticket can be grabbed as soon as its blockers close.
- The published tickets describe behaviour and criteria, not file paths or code that will go stale.

## Where it fits

`to-tickets-yes` is a **chain step** — the non-interactive sibling of `to-tickets`, sitting between the spec and the implement loop:

```txt
grill-with-docs → to-spec → to-tickets-yes → implement
```

Its closest neighbour is [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md) (the interactive version); the spec it slices against comes from [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md) or [to-prd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-prd/SKILL.md), and each ticket is built by [implement](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/implement/SKILL.md) one fresh context at a time. When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

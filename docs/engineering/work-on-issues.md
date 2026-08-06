Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=work-on-issues
```

```bash
npx skills update work-on-issues
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/work-on-issues)

## What it does

`work-on-issues` is an end-to-end issue driver: it fetches open GitHub or GitLab issues, filters to the main ones (titles starting with `PRD:` or `feat:`), implements them **one main issue at a time**, and closes them — handling parallel subtasks, dependency parsing, worktrees, and environment propagation along the way. The defining constraint: it works **one main issue at a time**, sequencing through a tracker rather than grabbing issues in a batch.

It detects the tracker host from `git remote -v` (`gh` or `glab`), marks the chosen issue `in-progress`, parses `## Blocked by` in the body to build a dependency graph (creating native tracker links where possible), then implements in a per-issue worktree, driving the build test-first and closing the issue when the work lands.

## When to reach for it

Type `/work-on-issues`, or the agent reaches for it when you ask it to "work through my issues", "pick up the next issue", or drive a queue of tracked issues to done.

Reach for it when you have agent-ready issues on a real tracker (produced by [to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md) or [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md)) and want one driver to fetch, implement, and close them in sequence. For building a single spec or ticket in isolation, use [implement](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/implement/SKILL.md) instead — `work-on-issues` is the queue driver that wraps that loop.

## Prerequisites

It operates on a configured GitHub or GitLab tracker (detected from `git remote`), so [setup-utarn-skills](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/setup-utarn-skills/SKILL.md) should have wired the tracker first. It expects issues to carry the `PRD:`/`feat:` title convention and a `## Blocked by` section when there are dependencies; unlabelled or sub-issues are skipped in auto/batch runs unless explicitly picked.

## One issue at a time

The defining idea is **one main issue at a time**. Each issue gets its own worktree (`.claude/worktrees/issue-<number>`), is marked `in-progress` (removing `ready-for-agent`/`needs-triage`), implemented against its acceptance criteria, and closed when done — with dependencies respected so a blocked issue isn't started before its blockers. Subtasks can run in parallel within an issue, but the main issues are sequenced.

## It's working if

- It detects `gh` vs `glab` from `git remote -v` and uses the right terminology (`pr`/`comment` vs `mr`/`note`).
- It filters to `PRD:`/`feat:` main issues, skips closed ones, and marks the chosen one `in-progress` before implementing.
- It parses `## Blocked by` and respects blocking order, creating native tracker links where the API allows.
- Each issue is implemented in its own worktree and closed when the work lands, not left open.

## Where it fits

`work-on-issues` is a **reach-for-it-anytime standalone** — the queue driver that wraps the implement → review → close loop for tracked issues. It sits downstream of the issue-splitting skills ([to-issues](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-issues/SKILL.md), [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md)) and drives the same per-issue build that [implement](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/implement/SKILL.md) does for a single ticket. When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

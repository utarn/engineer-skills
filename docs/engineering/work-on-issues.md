## What it does

`work-on-issues` is an end-to-end issue driver: it fetches open GitHub or GitLab issues, filters to the main ones (titles starting with `PRD:` or `feat:`), implements them **one main issue at a time**, audits each implementation against its acceptance criteria, and closes them — handling parallel subtasks, dependency parsing, worktrees, and environment propagation along the way.

The loop runs on a strict split: the orchestrator never touches code. Every issue — in single-issue, batch, and onwards modes alike — is implemented by a dispatched [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent), and each dispatch carries the full issue body, its comments, and the parent PRD's body and comments, because the prompt is the implementer's only context — a constraint not inlined there does not exist for it.

## When to reach for it

Type `/work-on-issues`, or the agent reaches for it when you ask it to "work through my issues", "pick up the next issue", or drive a queue of tracked issues to done.

Reach for it when you have agent-ready issues on a real tracker (produced by [to-issues](https://aihero.dev/skills-to-issues) or [to-tickets](https://aihero.dev/skills-to-tickets)) and want one driver to fetch, implement, and close them in sequence. For building a single spec or ticket in isolation, use [implement](https://aihero.dev/skills-implement) instead — `work-on-issues` is the queue driver that wraps that loop.

## Prerequisites

It operates on a configured GitHub or GitLab tracker (detected from `git remote`), so [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) should have wired the tracker first. It expects issues to carry the `PRD:`/`feat:` title convention and a `## Blocked by` section when there are dependencies; unlabelled or sub-issues are skipped in auto/batch runs unless explicitly picked.

## One issue at a time

Each issue gets its own worktree (`.claude/worktrees/issue-<number>`), is marked `in-progress` (removing `ready-for-agent`/`needs-triage`), implemented against its acceptance criteria, audited, and closed when done — with dependencies respected so a blocked issue isn't started before its blockers. Subtasks can run in parallel within an issue, but the main issues are sequenced.

## The audit is a second pair of eyes

An implementation is **resolved** when its commit lands, not when it is accepted. As soon as the implementer commits, the issue is marked `resolved` and an independent auditor subagent is dispatched — it does not wait for the PR to be opened or merged.

The auditor starts fresh, with the issue body, acceptance criteria, comments, and parent PRD inlined, and reviews the commit range with [code-review](https://aihero.dev/skills-code-review) and [find-mismatch](https://aihero.dev/skills-find-mismatch), plus `fallow` on JS/TS. It answers two questions: is anything left unimplemented (stubs, TODOs, unwired paths, missing tests), and is what landed actually faithful to each criterion? If it finds gaps, a fixer subagent repairs them in the same worktree and commits again (`fix: audit #<number> — …`), then the audit re-runs. The PR is gated on a clean verdict.

In batch mode the audit for issue N can overlap the implementation of issue N+1, so audits do not serialize the queue; the merge for N still waits for N's audit.

## The dispatch carries the context

The orchestrator fetches the full issue and its comments, resolves the parent PRD (a `PRD:`-prefixed or `PRD`-labelled issue whose body references this one), and inlines the issue body, the issue comments, and the PRD's body and comments verbatim into the implementer's prompt. An acceptance-criteria line like "follows PRD #3" carries no weight on its own — the PRD's actual constraints have to be in the prompt for the implementer to honour them. Subtask fan-out inside an issue follows the same rule: every subtask prompt carries the excerpts that bear on it, so no fresh context starts empty.

## Common questions

**Why dispatch a subagent for a one-line issue?** Because the treatment stays uniform at every size: the orchestrator's window stays lean across a long batch run, the implementer starts with a clean context holding exactly the issue's constraints, and every issue gets the same worktree → dispatch → verify → merge path. "Too small to bother dispatching" is the case the rule exists to catch.

**Does the audit block the next issue?** No. In batch mode the audit is dispatched as soon as the issue is marked resolved and can run while the next issue is implemented. The merge and close for that issue still wait for its own clean verdict, so the queue keeps moving without accepting unaudited work.

**Why audit after the implementer already ran `/find-mismatch`?** They answer different questions. `find-mismatch` is a runtime-bug and static-analysis pass inside the implementer's own context; the audit is an independent read against the ticket's acceptance criteria, looking for work that was never finished, tests that do not prove the criterion, or shortcuts the issue rules out. One catches contract mismatches; the other catches incompleteness.

## It's working if

- It detects `gh` vs `glab` from `git remote -v` and uses the right terminology (`pr`/`comment` vs `mr`/`note`).
- It filters to `PRD:`/`feat:` main issues, skips closed ones, and marks the chosen one `in-progress` before implementing.
- It parses `## Blocked by` and respects blocking order, creating native tracker links where the API allows.
- The dispatch prompt you see in the trace contains the issue body, the comments, and the parent-PRD text — not just a title and acceptance criteria.
- You never see the orchestrator edit a file, run a build, or fix a test itself; implementation only ever happens inside a dispatched subagent's worktree.
- Every resolved issue gets a fresh-context audit before its PR opens; the trace shows the `resolved` mark and the auditor's verdict.
- Audit findings come back as unimplemented behaviour or criteria violations with file references, not a vague "looks good".
- Fixes from the audit land as a separate `fix: audit #<number>` commit, and the audit re-runs against it.
- Each issue lands in its own worktree and is closed when the work lands, not left open.
- Batch runs overlap audits with the next implementation instead of waiting serially for each review.

## Where it fits

`work-on-issues` is a **reach-for-it-anytime standalone** — the queue driver that wraps the implement → review → close loop for tracked issues. It sits downstream of the issue-splitting skills ([to-issues](https://aihero.dev/skills-to-issues), [to-tickets](https://aihero.dev/skills-to-tickets)) and drives the same per-issue build that [implement](https://aihero.dev/skills-implement) does for a single ticket. When you're unsure which skill or flow fits, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

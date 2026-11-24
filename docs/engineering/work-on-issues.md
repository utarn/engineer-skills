## What it does

`work-on-issues` is an end-to-end issue driver: it fetches open GitHub or GitLab issues, filters to the main ones (titles starting with `PRD:` or `feat:`), implements them **one main issue at a time**, and closes them — handling parallel subtasks, dependency parsing, worktrees, and environment propagation along the way.

The loop runs on a strict split: the orchestrator never touches code. Every issue — in single-issue, batch, and onwards modes alike — is implemented by a dispatched [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent), and each dispatch carries the full issue body, its comments, and the parent PRD's body and comments, because the prompt is the implementer's only context — a constraint not inlined there does not exist for it.

## When to reach for it

Type `/work-on-issues`, or the agent reaches for it when you ask it to "work through my issues", "pick up the next issue", or drive a queue of tracked issues to done.

Reach for it when you have agent-ready issues on a real tracker (produced by [to-issues](https://aihero.dev/skills-to-issues) or [to-tickets](https://aihero.dev/skills-to-tickets)) and want one driver to fetch, implement, and close them in sequence. For building a single spec or ticket in isolation, use [implement](https://aihero.dev/skills-implement) instead — `work-on-issues` is the queue driver that wraps that loop.

## Prerequisites

It operates on a configured GitHub or GitLab tracker (detected from `git remote`), so [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) should have wired the tracker first. It expects issues to carry the `PRD:`/`feat:` title convention and a `## Blocked by` section when there are dependencies; unlabelled or sub-issues are skipped in auto/batch runs unless explicitly picked.

## One issue at a time

Each issue gets its own worktree (`.claude/worktrees/issue-<number>`), is marked `in-progress` (removing `ready-for-agent`/`needs-triage`), implemented against its acceptance criteria, and closed when done — with dependencies respected so a blocked issue isn't started before its blockers. Subtasks can run in parallel within an issue, but the main issues are sequenced.

## Verification happens inside the implementation phase

The implementer does not just write code and stop. Before it commits, it checks its own output and diff, runs the tests, runs [find-mismatch](https://aihero.dev/skills-find-mismatch) on the modified files, and — on JS/TS projects — runs `npx fallow audit`. Any error it finds is fixed and the tests re-run before the commit lands. The commit is the `fix: resolve #<number> — …` commit, and the issue is immediately marked `resolved` with a comment naming that commit.

There is no separate auditor pass after the commit: the verification and the implementation share one context, one worktree, and one commit sequence.

## The dispatch carries the context

The orchestrator fetches the full issue and its comments, resolves the parent PRD (a `PRD:`-prefixed or `PRD`-labelled issue whose body references this one), and inlines the issue body, the issue comments, and the PRD's body and comments verbatim into the implementer's prompt. An acceptance-criteria line like "follows PRD #3" carries no weight on its own — the PRD's actual constraints have to be in the prompt for the implementer to honour them. Subtask fan-out inside an issue follows the same rule: every subtask prompt carries the excerpts that bear on it, so no fresh context starts empty.

## Common questions

**Why dispatch a subagent for a one-line issue?** Because the treatment stays uniform at every size: the orchestrator's window stays lean across a long batch run, the implementer starts with a clean context holding exactly the issue's constraints, and every issue gets the same worktree → dispatch → verify → merge path. "Too small to bother dispatching" is the case the rule exists to catch.

**Where does verification live now?** In the implementer's post-implementation step: `/find-mismatch` on the modified files, `fallow audit` for JS/TS, and the project's test suite, all before the commit. Anything that fails is fixed and re-tested in the same worktree.

**What does verification catch — and what doesn't it?** `/find-mismatch` covers runtime contract mismatches and static analysis, and `fallow` catches security and correctness issues in JS/TS. Both read the code as written. Neither independently re-reads the ticket's acceptance criteria, so a criterion that was never implemented is caught only if the implementer notices it or a test proves it.

## It's working if

- It detects `gh` vs `glab` from `git remote -v` and uses the right terminology (`pr`/`comment` vs `mr`/`note`).
- It filters to `PRD:`/`feat:` main issues, skips closed ones, and marks the chosen one `in-progress` before implementing.
- It parses `## Blocked by` and respects blocking order, creating native tracker links where the API allows.
- The dispatch prompt you see in the trace contains the issue body, the comments, and the parent-PRD text — not just a title and acceptance criteria.
- You never see the orchestrator edit a file, run a build, or fix a test itself; implementation only ever happens inside a dispatched subagent's worktree.
- The implementer returns a summary that names the find-mismatch fixes, the fallow result, and the tests it ran.
- The issue is marked `resolved` when the implementer commits, and closed when the PR/MR merges.
- Each issue lands in its own worktree and is closed when the work lands, not left open.
- Batch runs move straight from one issue's merge to the next issue's implementation.

## Where it fits

`work-on-issues` is a **reach-for-it-anytime standalone** — the queue driver that wraps the implement → verify → close loop for tracked issues. It sits downstream of the issue-splitting skills ([to-issues](https://aihero.dev/skills-to-issues), [to-tickets](https://aihero.dev/skills-to-tickets)) and drives the same per-issue build that [implement](https://aihero.dev/skills-implement) does for a single ticket. When you're unsure which skill or flow fits, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

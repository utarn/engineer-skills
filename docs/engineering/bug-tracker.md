## What it does

`bug-tracker` works your **public bug tracker** — the separate GitHub repo where users and testers file bugs, feedback, and feature requests against a shipped product — as an **actionable** queue. Each run pulls open issues, buckets them into queues, then walks them one at a time: inspect and verify the issue against source code and attachments (screenshots inspected visually, sample files opened in `/tmp`, stack traces traced to the code path), apply taxonomy tags, mark `in-progress`, dispatch an isolated [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) in a [worktree](https://www.aihero.dev/ai-coding-dictionary/worktree) to solve and test the problem (similar to [work-on-issues](https://aihero.dev/skills-work-on-issues)), post a resolution summary comment back to the public tracker repo with the AI disclaimer, mark it `resolved`, and close the issue before loading the next one.

The defining constraint: the reports and the code live in different repos. You run the skill from the source codebase while the issues sit on the tracker, which is why it can verify a report against real subsystems, solve the issue in local worktrees, and sync resolution state back to the public tracker.

## When to reach for it

You invoke this by typing `/bug-tracker` — the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own. Pass a repo to point it somewhere new (`/bug-tracker owner/repo`), or a bare issue number (`/bug-tracker 42`) to skip the queue and jump straight to that one.

| What you have | Where to go |
| --- | --- |
| Raw user and tester reports on a separate public tracker repo to investigate and solve | `/bug-tracker` |
| Incoming issues on this repo's own tracker | [triage](https://aihero.dev/skills-triage) |
| Feature issues or tickets on this repo's tracker ready to build | [work-on-issues](https://aihero.dev/skills-work-on-issues) |
| A confirmed bug that needs a root cause before any label | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| Tickets you created yourself, ready to build | [implement](https://aihero.dev/skills-implement) |

## Prerequisites

The `gh` CLI, authenticated, with write access to the tracker repo. And `/init-bug-tracker` run once: it creates the label taxonomy this skill drives (states, types, priorities, `area:*` labels) and records the tracker repo in your `## Agent skills` config so the skill knows where reports live. No record yet? The first run asks, then records it.

## The queue, one issue at a time

The filter is the discipline: an issue is actionable only if it is open, not waiting on the reporter, and waiting on *you* — never triaged, marked `needs-triage`, or sitting ready to execute. A `needs-info` with no reporter reply, an `in-progress` with an active assignee/run, and anything `wontfix` or `resolved` are excluded from the pass; a `needs-info` whose reporter *did* reply re-enters the queue.

Then the one-at-a-time loop:
1. **Investigate & verify**: Inspect description, comments, and attachments (screenshots, sample files, logs) against the source code to reproduce the issue and identify root cause. Apply category (`bug`, `enhancement`), priority (`priority:*`), area (`area:*`), and verification (`tester-verified` / `needs-reproduction`) tags.
2. **Mark `in-progress`**: Set `in-progress` label on the tracker repo while working on the fix.
3. **Solve via subagent**: Create an isolated worktree (`.claude/worktrees/issue-<number>`), copy `.env` files, and dispatch a subagent to implement the fix, run tests, execute `/find-mismatch`, and run `fallow` audits.
4. **Resolve & close**: Propagate env files back, clean up worktree, post a resolution comment on the public tracker with the AI disclaimer, mark `resolved`, and close the issue.

Non-solvable issues are routed cleanly: `wontfix` closed with reasons, `needs-info` commented with specific missing reproduction details, or `ready-for-human` for design/hardware decisions.

## Common questions

**How is this different from `/triage` and `/work-on-issues`?**
[triage](https://aihero.dev/skills-triage) and [work-on-issues](https://aihero.dev/skills-work-on-issues) operate on the tracker hosted directly on the source repository. `bug-tracker` bridges two worlds: the issues sit on a separate *public* GitHub tracker (where users report issues), while the code lives locally. It combines public triage (investigating raw reports, parsing attachments, managing public taxonomy) with subagent-driven implementation, syncing resolution comments and state changes back to the public tracker.

**Do I have to pass the repo every time?**
No — pass it once and it's remembered. The tracker resolves from the `### Bug tracker` line under `## Agent skills` in your `CLAUDE.md`/`AGENTS.md`, written by `/init-bug-tracker` (or recorded by `/bug-tracker` itself if it had to ask). Edit that line when the tracker moves.

**Does it look at attachments, or only the issue text?**
The attachments are first-class evidence. Screenshots and screen recordings are downloaded and inspected visually for the error or clipped UI they show; sample files land in `/tmp` and get their structure examined; console logs are read for the exact stack trace and IPC call to trace. The verification step is only as strong as this pass.

**How does it isolate code changes while solving issues?**
Like `work-on-issues`, each issue is solved inside an isolated git worktree (`.claude/worktrees/issue-<number>`) by a dispatched subagent. The orchestrator never writes code or runs tests directly in the root workspace during implementation. Once verified, changes merge cleanly and worktrees are removed.

**Does it post comments to the public tracker?**
Yes. Every public comment opens with `> *This was generated by AI during bug-tracker triage.*` and summarizes the investigation, questions for `needs-info`, or resolution details (root cause, fix summary, verification tests) upon completion.

## It's working if

- Every actionable issue is investigated and tagged with appropriate category, area, priority, and verification tags.
- Issues actively being solved show `in-progress` on the public tracker.
- Subagents implement and test fixes in isolated worktrees without polluting the main directory.
- Tracker comments open with `> *This was generated by AI during bug-tracker triage.*`, and resolved issues receive a resolution summary comment, a `resolved` label, and are closed with reason `completed`.
- After an issue is resolved, the next issue loads without prompting until the queue is empty.

## Where it fits

An **on-ramp & execution loop**: the public-facing sibling of [triage](https://aihero.dev/skills-triage) and public counterpart to [work-on-issues](https://aihero.dev/skills-work-on-issues). It ingests raw public reports, validates them against code, and executes fixes end-to-end. Its setup half is [init-bug-tracker](https://aihero.dev/skills-init-bug-tracker), which creates the taxonomy and records the tracker. When you're not sure which lane you're in, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

## What it does

`bug-tracker` works your **public bug tracker** — the separate GitHub repo where users and testers file bugs, feedback, and feature requests against a shipped product — as an **actionable** queue. Each run pulls the open issues, buckets them into three queues, then walks them one at a time: read the full issue including its attachments — screenshots inspected visually, sample files opened, stack traces traced to the code path — check the claim against your source code, grill you through a round of questions where every question arrives with a recommendation attached, and apply the verdict — labels, summary comment, or close — before loading the next issue.

The defining constraint: the reports and the code live in different repos. You run the skill from the source codebase while the issues sit on the tracker, which is why it can verify a report against real subsystems before routing it.

## When to reach for it

You invoke this by typing `/bug-tracker` — the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own. Pass a repo to point it somewhere new (`/bug-tracker owner/repo`), or a bare issue number (`/bug-tracker 42`) to skip the queue and jump straight to that one.

| What you have | Where to go |
| --- | --- |
| Raw user and tester reports on a separate public tracker repo | `/bug-tracker` |
| Incoming issues on this repo's own tracker | [triage](https://aihero.dev/skills-triage) |
| A confirmed bug that needs a root cause before any label | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| Tickets you created yourself, ready to build | [implement](https://aihero.dev/skills-implement) |

## Prerequisites

The `gh` CLI, authenticated, with write access to the tracker repo. And `/init-bug-tracker` run once: it creates the label taxonomy this skill drives (states, types, priorities, `area:*` labels) and records the tracker repo in your `## Agent skills` config so the skill knows where reports live. No record yet? The first run asks, then records it.

## The queue, one issue at a time

The filter is the discipline: an issue is actionable only if it is open, not waiting on the reporter, and waiting on *you* — never triaged, marked `needs-triage`, or sitting ready to execute. A `needs-info` with no reporter reply, an `in-progress` with an active assignee, and anything `wontfix` are excluded from the pass; a `needs-info` whose reporter *did* reply re-enters the queue.

Then the one-at-a-time rule: the session never batches questions across issues. It grills one issue to a verdict, posts the outcome, announces the remaining queue counts, and only then opens the next [grilling](https://www.aihero.dev/ai-coding-dictionary/grilling) session — continuing until the actionable queue is empty or you stop it. Every question carries the skill's recommendation, so you react rather than author answers from scratch. A session that runs long usually means the queue is full of under-specified reports, not that the loop is slow.

## Common questions

**How is this different from `/triage`?**
Same state-machine idea, different input surface. [triage](https://aihero.dev/skills-triage) works the tracker that sits on the repo — issues filed against the code itself — and its endpoint is an agent brief. `bug-tracker` works a separate public repo full of raw reports from *users*, where half the job is deciding whether the thing is even a bug, what it's worth, and whether the reporter owes reproduction steps. The taxonomies overlap — triage's five canonical roles are a subset of this one, plus priorities, areas, and verification tags. Teams running both use `triage` for the work tracker and `bug-tracker` for the public one.

**Do I have to pass the repo every time?**
No — pass it once and it's remembered. The tracker resolves from the `### Bug tracker` line under `## Agent skills` in your `CLAUDE.md`/`AGENTS.md`, written by `/init-bug-tracker` (or recorded by `/bug-tracker` itself if it had to ask). Edit that line when the tracker moves.

**Does it look at attachments, or only the issue text?**
The attachments are first-class evidence. Screenshots and screen recordings are downloaded and inspected visually for the error or clipped UI they show; sample files land in `/tmp` and get their structure examined; console logs are read for the exact stack trace and IPC call to trace. The verification step is only as strong as this pass.

**Does it ever close an issue on its own?**
Closing is a verdict you agreed to — `wontfix`, duplicate, invalid — never something that happens to a queued issue without the grilling round.

**Does it work with GitLab or another tracker?**
GitHub only for now; every step runs on the `gh` CLI.

## It's working if

- Every issue it touched ends with exactly one state label and one category label — never zero, never two states in conflict.
- Each grilling question comes with a recommendation, and you mostly say "yes" or "no, because…".
- Tracker comments open with `> *This was generated by AI during bug-tracker triage.*`, and `needs-info` comments name the exact missing artifact — a reproduction step, a sample file, a log — instead of "please provide more info".
- After a verdict, the next issue loads without you asking, and the run stops only on an empty queue or your stop word.

## Where it fits

An **on-ramp**: the public-facing sibling of [triage](https://aihero.dev/skills-triage). Both generate work and both merge into the main flow — an issue left at `ready-for-agent` is picked up by [implement](https://aihero.dev/skills-implement) exactly like a ticket from [to-tickets](https://aihero.dev/skills-to-tickets). Its setup half is [init-bug-tracker](https://aihero.dev/skills-init-bug-tracker), which creates the taxonomy and records the tracker. When you're not sure which lane you're in, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

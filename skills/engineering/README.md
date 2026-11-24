# Engineering

Skills I use daily for code work.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[ask-utarn](./ask-utarn/SKILL.md)**: Ask which skill or flow fits your situation. A router over the user-invoked skills in this repo.
- **[grill-with-docs](./grill-with-docs/SKILL.md)**: Grilling session that also builds your project's domain model, sharpening terminology and updating `GLOSSARY.md` and ADRs inline.
- **[grill-novice](./grill-novice/SKILL.md)**: Grilling session that asks you only the functional requirements, in plain simplified English, while the agent settles every technical detail itself.
- **[triage](./triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[bug-tracker](./bug-tracker/SKILL.md)**: Work the actionable queue of a public GitHub bug tracker one issue at a time: investigate and verify, tag, solve via subagents, comment, mark resolved, and close.
- **[init-bug-tracker](./init-bug-tracker/SKILL.md)**: Initialize or re-sync a bug tracker's label taxonomy and issue forms, and record the tracker for the other skills.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick.
- **[setup-utarn-skills](./setup-utarn-skills/SKILL.md)**: Configure this repo for the engineering skills (issue tracker, triage labels, domain doc layout). Run once per repo.
- **[setup-utarn-skills-yes](./setup-utarn-skills-yes/SKILL.md)**: Like `/setup-utarn-skills`, but accepts every recommended default and writes the configuration without a confirmation round.
- **[to-issues](./to-issues/SKILL.md)**: Break any plan, spec, or PRD into independently-grabbable issues using vertical slices.
- **[to-issues-yes](./to-issues-yes/SKILL.md)**: Like `/to-issues`, but assumes you approve the breakdown and publishes straight to the tracker.
- **[to-prd](./to-prd/SKILL.md)**: Turn the current conversation into a PRD and publish it to the issue tracker.
- **[to-spec](./to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker.
- **[to-spec-yes](./to-spec-yes/SKILL.md)**: Like `/to-spec`, but assumes you approve the proposed seams and publishes without a seam check.
- **[to-tickets](./to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges, whether as text in a local file or as native blocking links on a real tracker.
- **[to-tickets-yes](./to-tickets-yes/SKILL.md)**: Like `/to-tickets`, but assumes you approve the breakdown and publishes straight to the tracker.
- **[implement](./implement/SKILL.md)**: Build the work described by a spec or set of tickets, driving `/tdd` at pre-agreed seams and closing out with `/code-review` before committing.
- **[implement-spec](./implement-spec/SKILL.md)**: Implement a whole spec on one integration branch. Works the tickets as a task graph, running implementer subagents across the ready frontier for maximum concurrency, then closes out with `/code-review`.
- **[wayfinder](./wayfinder/SKILL.md)**: Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on the issue tracker, resolved one at a time until the way to the destination is clear.
- **[wayfinder-yes](./wayfinder-yes/SKILL.md)**: Like `/wayfinder`, but asks only the feature direction (plus a prototype choice), resolves the whole frontier itself, and builds the complete feature — no interview rounds and no v1/v2 phasing.
- **[retro](./retro/SKILL.md)**: Suggest improvements to the coding agent's environment (navigation, automated checks, coding standards, steering files, tooling) after a session, most severe first.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[prototype](./prototype/SKILL.md)**: Build a throwaway prototype to answer a design question: a single shareable HTML file for state/logic, or several toggleable UI variations.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions: build a feedback loop that goes red on this bug → minimise → hypothesise → instrument → fix → regression-test.
- **[research](./research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Actively build and sharpen a project's domain model by challenging terms, stress-testing with scenarios, and updating `GLOSSARY.md` and ADRs inline.
- **[codebase-design](./codebase-design/SKILL.md)**: Shared discipline and vocabulary for designing deep modules: small interfaces, clean seams, testable through the interface.
- **[find-mismatch](./find-mismatch/SKILL.md)**: Systematic code review focusing on bugs that break at runtime and JS/TS static analysis via fallow.
- **[code-review](./code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: **Standards** (does it follow the repo's coding standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?), run as parallel sub-agents.
- **[pr](./pr/SKILL.md)**: The shape a pull request body should take: a summary as the smallest visual that makes the change clear, before/after evidence that it works, and a merge-danger call (one-way or two-way door, plus blast radius).
- **[work-on-issues](./work-on-issues/SKILL.md)**: Fetch, implement, and close GitHub/GitLab issues sequentially (one main issue starting with PRD:/feat: at a time).

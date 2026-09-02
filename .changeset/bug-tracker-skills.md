---
"utarn-skills": minor
---

Add `bug-tracker` and `init-bug-tracker`, a user-invoked pair for running a public bug tracker repo — the separate GitHub repo where users and testers file reports against a shipped product.

- `init-bug-tracker` creates the label taxonomy on the tracker — triage states, types, priorities, verification tags, and `area:*` labels derived from your repo rather than copied from a fixed list — seeds the repo with structured issue forms (bug report and feature request with OS and component-area dropdowns, blank issues disabled) and a tracker README, then records the tracker under the `## Agent skills` config so the other skills find it. Idempotent: re-run it whenever the taxonomy drifts.
- `bug-tracker` works the actionable queue one issue at a time: fetch and bucket the queue, inspect the issue against the source codebase — attachments included, with screenshots inspected visually and sample files examined — run a `/grilling` session where every question carries a recommendation, apply the verdict (labels, summary comment, or close), and advance to the next issue.

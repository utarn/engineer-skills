---
"utarn-skills": patch
---

`to-tickets-yes` now ends the planning phase on a clean tree. Once the tickets are published, it checks `git status --short` and commits the uncommitted **planning artifacts** the flow left behind — `CONTEXT.md` / `CONTEXT-MAP.md`, `docs/adr/` files, the PRD or spec markdown, and the local ticket files under `.scratch/<feature-slug>/issues/`. Those paths are staged individually — never a blanket `git add` — as a single `docs: <feature-slug> planning artifacts` commit, and a gitignored artifact path is surfaced rather than force-committed. The implement loop now starts from committed planning instead of a working tree full of loose planning paper.

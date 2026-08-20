---
name: grill-novice
description: A grilling session that asks you only the functional requirements, in plain simplified English, while the agent settles every technical detail itself and recaps the assumptions for your veto before anything is written.
disable-model-invocation: true
---

Run a `/grilling` session, using the `/domain-modeling` skill, with three changes:

1. **Split the frontier.** Every decision in the design tree is either a **functional requirement** — observable behaviour the system must deliver, from the user's perspective — or a **technical detail** — architecture, data model, API shape, error handling, numeric defaults, anything the system can settle. Ask the user only the functional-requirement questions. Settle every technical detail yourself: pick your recommendation and record it for the recap, don't ask.

2. **Write the questions you do ask in STE-style plain English.** Short sentences, one idea per sentence, common words, no jargon. Keep the standard question shape — `❓` numbered with a title, your recommendation alone on a `➡️` line — and give a recommendation for every functional-requirement question too, so the user can answer by number.

3. **Gate all writing on a recap.** Nothing lands in `CONTEXT.md` or `docs/adr/` until the frontier is empty and the user has approved the recap. Present, in one screen: the functional requirements you confirmed, and every technical detail you assumed — each with its recommendation and a one-line why. The user rejects any; reopen those branches and recompute the downstream tree. Only then write: terms to `CONTEXT.md`, decisions that pass the three gates to `docs/adr/`.

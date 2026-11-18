## What it does

`grill-novice` interviews you about a plan or design until you and the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) share one understanding of it, then writes the vocabulary and the hard decisions into your repo. It is the same [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful) [grill-with-docs](https://aihero.dev/skills-grill-with-docs) [session](https://www.aihero.dev/ai-coding-dictionary/session) with the interview turned down: the agent settles every technical detail itself, and the only questions it asks you are the functional requirements — the observable behaviour the system must deliver — written in short, plain English.

The defining constraint is the split. Every decision in the design tree is either a functional requirement or a technical detail. Technical details are assumed, not quizzed; functional requirements are asked, but only in simplified-technical-English style. And nothing is written to disk until you have approved a recap of everything the agent assumed.

## When to reach for it

You invoke this by typing `/grill-novice` — the agent won't reach for it on its own.

Reach for it at the start of a change, in a repo, when the plan is fuzzy but the technical decisions feel like the agent's call rather than yours. You want the alignment that grilling buys without being asked to decide things that aren't really your decisions to make.

| What you want | Reach for |
| --- | --- |
| The full interview — you answer every decision | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| Only the functional requirements asked, technical details assumed | `/grill-novice` |
| The same, but no repo and no files written | [grill-me](https://aihero.dev/skills-grill-me) |

## Prerequisites

The skill writes into your repo, so you need to be somewhere it is safe to write — resolved terms go to a `GLOSSARY.md` glossary and gated decisions to `docs/adr/`, both created lazily. It also needs the [grilling](https://aihero.dev/skills-grilling) and [domain-modeling](https://aihero.dev/skills-domain-modeling) skills installed, because its own `SKILL.md` delegates to them; installing `grill-novice` alone gets you a skill that does not work.

## The split

The session maps your idea as a design tree and divides it once:

- **Functional requirements** — what the system must do, from the user's perspective. These are asked of you, in the standard grilling shape: `❓` numbered, with the agent's recommendation alone on a `➡️` line, so you can answer the whole round by number.
- **Technical details** — architecture, data model, API shape, error handling, defaults. The agent settles each itself, picks its recommendation, and records it for the recap. They never interrupt the interview.

The questions that do reach you are written STE-style: short sentences, one idea per sentence, common words, no jargon — the spirit of ASD-STE100 Simplified Technical English, not the full controlled vocabulary. The point is that the reader is never asked to decode technical language in order to say whether a behaviour is right.

## The recap

Nothing is written until the frontier is empty. Then the agent presents one screen: the functional requirements you confirmed, and every technical detail it assumed — each with its recommendation and a one-line why. Reject any assumption and the branch reopens; the downstream tree recomputes before anything lands. Only after you approve does [domain-modeling](https://aihero.dev/skills-domain-modeling) write terms to `GLOSSARY.md` and gated decisions to `docs/adr/`.

This is the deliberate contrast with [grill-with-docs](https://aihero.dev/skills-grill-with-docs), which writes inline as terms resolve. `grill-novice` writes nothing until the veto gate passes, because the assumed decisions are exactly the ones you haven't heard yet.

## Common questions

**This is just `grill-with-docs` with fewer questions. Why not use that?**
The burden is where the difference is. `grill-with-docs` makes you answer every frontier decision, including the technical ones. `grill-novice` only asks you the functional requirements and lets you veto the agent's technical assumptions in one screen at the end. If answering technical questions is exactly what you're trying to avoid, this is the skill for you.

**What if I disagree with an assumed decision?**
That is what the recap is for. Reject it and the branch reopens; the agent recomputes what the rejection changes and re-runs the affected round before anything is written.

**Why are the questions written in such simple English?**
The questions you answer are functional requirements, and they are written in the spirit of ASD-STE100 Simplified Technical English — short sentences, one idea per sentence, common words. The interview should not require you to read technical language you would rather not.

**When does anything appear in my repo?**
Only after you approve the recap. Terms land in `GLOSSARY.md` and gated decisions in `docs/adr/` at the end of the session, not during it.

## It's working if

- The only questions reaching you are functional requirements — short, plain sentences you can answer by number.
- Technical decisions never interrupt the interview; they arrive as a batch at the recap.
- Nothing appears in `GLOSSARY.md` or `docs/adr/` until you have approved the recap.
- Rejecting one assumption at the recap visibly reshapes what would have been written.
- The session ends with a recap you can veto, not a pile of files you were never shown.

## Where it fits

`grill-novice` is a third named front-door to the [grilling](https://aihero.dev/skills-grilling) primitive, and it heads the same build chain as [grill-with-docs](https://aihero.dev/skills-grill-with-docs) — the interview feeds [to-spec](https://aihero.dev/skills-to-spec), then [to-tickets](https://aihero.dev/skills-to-tickets), then [implement](https://aihero.dev/skills-implement). Its siblings are `grill-with-docs` (the full-interview version) and [grill-me](https://aihero.dev/skills-grill-me) (stateless). When you're unsure which entry point fits, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

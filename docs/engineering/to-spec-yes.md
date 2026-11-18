## What it does

`to-spec-yes` turns the conversation you have just had into a **[spec](https://www.aihero.dev/ai-coding-dictionary/spec)** and publishes it to your issue tracker as a single issue — the same synthesis [to-spec](https://aihero.dev/skills-to-spec) performs, with one round removed: it sketches the seams the feature will be tested at, assumes you approve them, and writes and publishes without waiting for your word.

The defining constraint is inherited from `to-spec` unchanged — it does not interview you; it records decisions already made, in your project's own vocabulary. The "yes" is only that the seams it proposes are taken as agreed rather than checked. They are not skipped: they land in the spec's Testing Decisions section, which is where the rest of the chain picks them up.

## When to reach for it

You invoke this by typing `/to-spec-yes` — the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) won't reach for it on its own.

| Where you are | What to run |
| --- | --- |
| The seams are routine — an existing seam, placed where you'd place it yourself | `/to-spec-yes` |
| The seams are load-bearing — new seams, or a placement you want a say in | [to-spec](https://aihero.dev/skills-to-spec) |
| You haven't decided anything yet | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) first |

## Prerequisites

Same as `to-spec`: it publishes the spec as an issue, so [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) must have configured a tracker and the triage-label vocabulary for this repo first — either kind works, a real tracker or local markdown under `.scratch/`. The assume-defaults variant [setup-utarn-skills-yes](https://aihero.dev/skills-setup-utarn-skills-yes) configures it just as well.

## The seams still travel

The **seam** check exists in `to-spec` because the seams do not stay in the spec: [tdd](https://aihero.dev/skills-tdd) works only at pre-agreed seams, and [code-review](https://aihero.dev/skills-code-review) reviews the diff against the spec, so a seam nobody agreed to surfaces as a review finding. The binding is indirect — it runs through the spec document.

`to-spec-yes` keeps the binding and drops the conversation. The seams it assumes are written into the Testing Decisions section, so a fresh [session](https://www.aihero.dev/ai-coding-dictionary/session) implementing the spec — or reviewing it — sees exactly what was assumed and can push back there instead. What you lose is the cheapest place to catch a wrong seam: before anything is written, when moving it costs one sentence.

## Common questions

**What if the seams it assumed are wrong?**
Edit the spec issue before `/to-tickets` runs — the Testing Decisions section names them, so the assumption is visible after the fact. Past that point the fix costs more: tickets inherit the seams, and a seam moved during implementation shows up as review noise rather than a decision.

**Is this just `to-spec` with one line changed?**
It is `to-spec` byte-for-byte except the seam check, which is replaced by the instruction to assume your approval. That is deliberate: the base skill tracks upstream exactly, and the assume-yes behaviour is layered as a sibling so upstream changes rebase cleanly. If you want the interview-free synthesis *and* a say in the seams, that skill is `to-spec` unchanged.

## It's working if

- It never pauses to ask about seams — the trace runs from seam sketch straight to the published issue.
- The published spec's Testing Decisions section names the seams it assumed, so the assumption is auditable.
- Everything else reads like a `to-spec` run: your project's nouns, every decision traceable to the conversation, an out-of-scope section with real things in it.
- `/to-tickets` on the published spec works without asking where issues live.

## Where it fits

`to-spec-yes` is a **chain step** — the assume-yes sibling of [to-spec](https://aihero.dev/skills-to-spec), standing at the same point on the multi-session branch of the main flow:

```txt
grill-with-docs → to-spec-yes → to-tickets → implement → code-review
```

Its closest neighbour is `to-spec` (the interactive version — same document, one more conversation). Downstream, [to-tickets](https://aihero.dev/skills-to-tickets) cuts the spec into tracer-bullet tickets for [implement](https://aihero.dev/skills-implement) to build. When you're unsure which skill or flow fits, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes you.

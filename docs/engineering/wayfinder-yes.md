## What it does

`wayfinder-yes` is the assume-yes variant of [wayfinder](https://aihero.dev/skills-wayfinder). It takes an effort too big for one agent [session](https://www.aihero.dev/ai-coding-dictionary/session) and charts the same shared map of decision tickets on your issue tracker — but it asks the human exactly **one** question, the feature direction, and then answers every decision ticket itself. The map clears and the skill builds the complete feature, rather than handing a cleared map to a spec.

The defining constraint is the question budget: **one direction question per run, and implementation is never a question.** Modules, seams, schemas, dependencies, and test strategy belong to the [agent](https://www.aihero.dev/ai-coding-dictionary/agent). The second constraint is scope: the destination is the whole feature, with no v1/v2 split, no MVP, and no later version to defer behaviour into.

## When to reach for it

You invoke this by typing `/wayfinder-yes` — the agent won't reach for it on its own.

It is as heavy as `/wayfinder`, so the trigger is the same: the work must exceed a single session and the route to the destination must still be foggy. The choice between the two is about who holds the decisions.

| Situation | What to run |
| --- | --- |
| The effort is multi-session, and you trust the agent to make the implementation calls | `/wayfinder-yes` |
| The effort is multi-session, and the decisions are the point — you want to make them | [wayfinder](https://aihero.dev/skills-wayfinder) |
| You can settle the whole thing in one conversation | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| You already have a spec and only want the code | [implement](https://aihero.dev/skills-implement) |

## Prerequisites

The map and its tickets live on the repo's issue tracker, so [setup-utarn-skills](https://aihero.dev/skills-setup-utarn-skills) must have configured the tracker and its "Wayfinding operations" section for this repo first. With no tracker configured, it falls back to local markdown, exactly as `wayfinder` does.

## One question, then none

The direction question is the only place the human enters:

> Which direction should this feature take — what outcome do you want, and what is explicitly out of scope?

It is asked only when the invocation prompt does not already answer it. After that, no approval round exists for the map, the ticket breakdown, the destination, or the build. The agent settles each ticket, records the choice and its rationale, and moves on. A hard external blocker — a credential or access only a human can provision — may be surfaced once, as a step, not as an interview.

The trade is deliberate. `wayfinder` uses conversation to improve the decisions; `wayfinder-yes` spends that budget on autonomy. A wrong assumption shows up in the map's **Decisions so far**, where it is visible after the fact, instead of in a question asked before it.

## Full feature, no v1/v2

The destination is the complete feature. "v1", "MVP", "phase 1", and "we'll add the rest later" are not planning tools here. At every fork the agent picks the option that delivers the whole behaviour; if two options both deliver it, it picks the simpler architecture rather than the smaller feature. "Full flex" is the licence for implementation: refactor, add modules, change schema, and add dependencies without asking, provided the complete feature still lands.

Done means every behaviour the direction names works through its real path, with tests. Stubs, TODOs standing in for behaviour, and flags left off are unfinished, not shipped.

## The map still travels

The map, the child tickets, the fog of war, the frontier, and the `wayfinder:` labels are all unchanged, so a `wayfinder-yes` map and a `/wayfinder` map are the same artifact. What changes is the ticket modes: every one is [AFK](https://www.aihero.dev/ai-coding-dictionary/afk). Research runs in a subagent, prototypes are built and chosen by the agent, grilling becomes the agent's own question tree, and tasks are done in place.

The map earns its keep as the audit trail: it shows which decisions were taken, why, and what the fog hid. It is not an approval gate, and there is no hand-off to `/to-spec` or `/to-tickets`; the build is carried inside the map.

## Common questions

**How is this different from `/wayfinder`?**
Two differences. First, the human answers zero decision tickets — the single direction question is the whole interview. Second, it builds. `wayfinder` deliberately plans and hands off; `wayfinder-yes` carries the implementation to the end, with [tdd](https://aihero.dev/skills-tdd) driving the slices and [code-review](https://aihero.dev/skills-code-review) closing the diff.

**Why is there no v1/v2?**
Because a phased plan reintroduces the question this variant exists to remove: which slice is in, which is later, and who decides. The direction answer already fixes the feature, so the agent builds all of it. If you want a smaller first release, say so in the direction — that is a scope decision, and it belongs in the one question.

**What if the direction the agent inferred is wrong?**
Its decisions are written down in the map's **Decisions so far**, so the wrong branch is inspectable after the fact. Correcting it means editing the map and reopening the affected tickets; it does not need a new round of questions. The one direction question may be asked again only when new evidence makes two mutually exclusive directions equally plausible.

**Does it still create all those tickets?**
Yes. The map is the trace: it records the decisions the autonomy made, which is exactly what you need to audit a build nobody interviewed you about. If you do not want the trace at all, this is the wrong skill — a spec plus [implement](https://aihero.dev/skills-implement) is the lighter route.

## It's working if

- It asked at most one question, and that question was about direction, never implementation.
- The trace runs from the prompt to the destination without an approval pause or a "does this look right?".
- Every decision the agent made is one line in the map's **Decisions so far**, with a rationale in its ticket.
- The destination describes the complete feature, and the diff implements it end to end — no stubs, no TODOs standing in for behaviour, no "v2" note.
- `tdd` drove the build and `code-review` ran before the map closed.
- The map closes with a summary of what was built, the tests, and the review verdict.

## Where it fits

`wayfinder-yes` is a **variant on-ramp**, not the default and not a chain step. It merges onto the main flow only after it has built: it replaces the `wayfinder → to-spec → to-tickets → implement` chain with `wayfinder-yes → (build inside the map)`.

Its closest neighbour is [wayfinder](https://aihero.dev/skills-wayfinder) — same map, same fog, but the human holds the decisions and the skill stops at a cleared map. Downstream it uses [tdd](https://aihero.dev/skills-tdd) and [code-review](https://aihero.dev/skills-code-review) directly. For every other route, [ask-utarn](https://aihero.dev/skills-ask-utarn) routes over the whole set.

---
name: wayfinder-yes
description: The assume-yes wayfinder. Read the prompt, ask only the feature-direction question — plus a prototype choice when one is raised — then resolve the whole frontier and build the complete feature. No interview rounds and no v1/v2 phasing.
disable-model-invocation: true
---

A loose idea has arrived, too big for one agent session, and wrapped in fog: the way from here to the **destination** isn't visible yet. Wayfinding is about finding that way. This variant points the same map at the same destination, but removes the interview: it asks the human the **feature direction** only when the prompt does not already give it, and asks one more thing only when a prototype needs a human's taste — which variation to keep. Everything else is the agent's decision, and the complete feature gets built.

The map is the same artifact wayfinder produces: decision tickets on the issue tracker, fog of war, a frontier. The difference is who answers. In wayfinder the human answers every decision ticket; here the agent takes the whole frontier itself, choosing the most complete option each time and recording why. The one standing exception is a prototype, whose variations the human chooses.

## One direction question, one prototype choice

**Your question budget is two moments, and neither is an interview:** the feature-direction question, asked at most once per run; and a prototype choice, asked only when a prototype ticket presents variations a human should pick between.

1. **Read the invocation prompt first.** It is the user's direction statement. If it already names the outcome and the scope boundary — what the feature must do and where it stops — **ask nothing**. Go straight to the map and start resolving the frontier.
2. **If the direction is ambiguous, ask once**, in plain language, with a recommendation attached:

   > Which direction should this feature take — what outcome do you want, and what is explicitly out of scope?

3. **Do not ask a second direction question.** Everything the prompt and that answer leave open is yours to decide.
4. **A prototype is the only other question.** Build the variations, present them side by side, say which you recommend and why, and ask the human to choose. Record the choice and continue the loop. This is a design-taste decision, not an implementation question: it is the one place the human's preference wins over the full-feature rule.
5. **Nothing else is a question.** A ticket that feels like it needs the user is either the feature direction (already answered — interpret it), a prototype choice (handled above), or an implementation detail (yours).

Implementation is never a question. Modules, seams, schemas, APIs, dependencies, file layout, naming, test strategy, and migration shape are all yours. So are rollback, error handling, defaults, and sequencing.

Outside a prototype choice, the only other pause is a hard external blocker only a human can clear: a credential, a payment, or access you cannot provision. State the blocker and the exact step once, then continue on everything it does not block. Do not turn it into an interview.

If new evidence later contradicts the direction, do not ask a fresh round. Re-read the direction for the most complete reading it supports and revise the map. Only if the evidence makes two mutually exclusive directions equally plausible may you ask the direction question again — and then it is still the only direction question.

## Full feature, no v1/v2

The destination is the **complete feature**, not an MVP, a proof of concept, a phase 1, or "something shippable". There is no v1/v2 split, no milestone slicing, and no "later" backlog for behaviour the direction implies.

- **At every fork, choose the option that delivers the whole behaviour.** If two options both deliver it, choose the simpler architecture, never the smaller feature.
- **Full flexibility is the licence.** Refactor, add modules, change the schema, add a dependency, or move a seam whenever that serves the complete feature. You do not need permission for an implementation choice.
- **Out of scope means the direction says so.** It is not a place to park hard work. Everything the direction names is in scope until it demonstrably contradicts another part of the direction.
- **Done means end to end.** Every user-facing behaviour in the direction works through its real path, with tests. No stubs, no TODOs standing in for behaviour, no flags left off, no slice deferred to a version that does not exist.

## The map

The map is a single issue on this repo's issue tracker, labelled `wayfinder:map`, the canonical artifact. Its tickets are child issues of the map.

The map is an **index**, not a store. It lists the decisions made and points at the tickets that hold their detail; a decision lives in exactly one place, its ticket, so the map never restates it, only gists it and links.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** The issue tracker should have been provided to you. If not, tell the user to run `/setup-utarn-skills`. Consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them. If no tracker has been provided, default to the local-markdown tracker.

### The map body

The whole map at low resolution, loaded once per session. Open tickets are **not** listed: they are open child issues, found by query.

```markdown
## Destination

<the complete feature this map is building: the outcome, the scope boundary, and the behaviours it must deliver. The full feature, never an MVP. Every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort; and the variant's rule: this is a wayfinder-yes map — decide without asking, build the full feature, no v1/v2.>

## Decisions so far

<!-- the index: one line per closed ticket, enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link): <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Tickets

Each ticket is a **child issue** of the map; the tracker's issue id is its identity. Its body is the question, sized to one 100K token agent session:

```markdown
## Question

<the decision or investigation this ticket resolves>
```

Each ticket carries a `wayfinder:<type>` label, one of `research`, `prototype`, `grilling`, `task`. Keep the `wayfinder:` labels: the map and tickets interoperate with maps charted by `/wayfinder`.

A session **claims** a ticket by assigning it to the dev driving the map, **first**, before any work, so concurrent sessions skip it. That assignee _is_ the claim: an open, unassigned ticket is unclaimed.

Blocking uses the tracker's **native** dependency relationship: essential because it renders the frontier _visually_ in the tracker's own UI. Only a tracker that lacks native blocking falls back to a body convention. A ticket is **unblocked** when every ticket blocking it is closed; the **frontier** is the open, unblocked, unclaimed children, the edge of the known.

The answer isn't part of the body; it's recorded on resolution (see [Work the map](#work-the-map)). Assets created while resolving a ticket are linked from the issue, not pasted in.

## Ticket types here

Wayfinder separates **HITL** (a human speaks for themselves) from **AFK**. This variant is AFK for every decision except the prototype choice: the agent answers the decision tickets, and the human chooses the prototype variation. The labels stay for interoperability, but the modes change.

- **Research** (AFK): Reading documentation, third-party APIs, or local resources to surface a fact a decision waits on. Resolved by a subagent that calls the Skill tool with "research", run in parallel on a `research/<name>` branch. Knowledge outside the working directory.
- **Prototype** (HITL): Call the Skill tool with "prototype" to build the cheap, rough artifact and its variations. Then **ask the human which variation to keep**, presenting them side by side with your recommendation. Link the chosen variation from the ticket and continue the frontier. Never choose for the human here: prototype choice is the exception to assume-yes.
- **Grilling** (AFK here): The default case. **Do not interview the user.** Call the Skill tool with "domain-modeling", then run the grilling discipline yourself in AFK mode: enumerate the branches of the question, answer each with your recommendation, and record the rationale in the ticket's resolution. No question is sent to the human. A HITL grilling ticket inherited from a `/wayfinder` map is resolved the same way.
- **Task** (AFK, via subagents): Work that must happen before a decision can be made, such as provisioning access or moving data so its shape can be seen. **Dispatch subagents to do it and keep the loop moving.** Run independent tasks in parallel, record what they did, and continue to the next frontier ticket. Do not ask whether to do it. If a step is genuinely human-only, surface that single blocker and its exact step; otherwise it is the subagents' work.

## Fog of war

The map is _deliberately_ incomplete: don't chart what you can't yet see. Beyond the live tickets lies the **fog of war**: the dim view of decisions you can tell are coming but can't yet pin down. Resolving a ticket clears the fog ahead of it, graduating whatever's now specifiable into fresh tickets, one at a time, until the way to the destination is clear and no tickets remain.

The map's **Not yet specified** section is where that dim view is written down. It is the undiscovered frontier _toward_ the destination: in scope, just not sharp enough to ticket.

**Fog or ticket?** The test is whether you can state the question precisely now, _not_ whether you can answer it now.

- **Ticket when** the question is already sharp, even if it's blocked.
- **Not yet specified when** you can't yet phrase it that sharply. Don't pre-slice the fog into ticket-sized pieces.

**Not yet specified** excludes what's already decided, what's already a live ticket, and what's out of scope.

## Out of scope

Fog only ever gathers _toward_ the destination. The destination fixes the scope, so work beyond it is **out of scope**: it isn't fog, and it doesn't belong in **Not yet specified**. It gets its own **Out of scope** section: work you've consciously ruled out of _this_ effort. Scope, not sharpness, lands it here.

Out-of-scope work never graduates. When a ticket turns out to sit past the destination, **close it** and leave one line in the **Out of scope** section: the gist plus why, linking the closed ticket. It stays out of **Decisions so far**, which records the route actually walked.

## Work the map

User invokes with a loose idea, optionally with a map to resume (URL or number). A ticket is optional: without one, take the first frontier ticket.

1. **Read the prompt.** If a map was passed, load it at low resolution and go to step 4. Otherwise, ask the one direction question only if the prompt does not already answer it.
2. **Name the destination.** From the prompt and the direction answer, write the complete feature as the Destination. Call the Skill tool with "domain-modeling" to keep the vocabulary clean. Settle this before any ticket exists: it fixes the scope.
3. **Chart the map.** Create it with the `wayfinder:map` label: Destination and Notes filled in, Decisions-so-far empty, the fog sketched into **Not yet specified**. Create the tickets you can specify now as child issues, then wire blocking edges in a **second pass** (issues need ids first). Fire a fresh-context research subagent for each `research` ticket. Do not present the map for approval.
4. **Resolve the frontier, ticket by ticket.** Take the next frontier ticket, claim it, and resolve it as its `wayfinder:<type>` label names. Except for a prototype choice, the answer is yours, chosen for the fullest feature: pick the most complete option, not the smallest. Record the resolution as a **resolution comment** with the rationale, close the issue, and append a context pointer to **Decisions so far**. Then graduate any fog the answer made specifiable, clear each graduated patch from **Not yet specified**, and refresh the frontier. If the answer puts a ticket past the destination, rule it out of scope; if it invalidates other tickets, update or delete them.
5. **Keep taking frontier tickets until there is no frontier left.** This is a loop, not a checklist: while an open, unblocked, unclaimed child exists, take it and resolve it, then take the next. Do not stop for approval, a status update, or a check-in between tickets. The only pauses are a **prototype choice** (ask the human to pick a variation) and a genuinely human-only blocker. If no direction question was needed, there is no pause at all before the first ticket. When context fills mid-loop, leave the map current and continue in a fresh session from the map — the map is the handoff, so nothing is lost and nothing is asked. When fog graduates into new tickets, the frontier refills and the loop continues; stop only when both the frontier and the fog are empty.
6. **Build the full feature.** With no decisions left, implement the complete Destination. Drive the work with the Skill tool "tdd", one red-green slice at a time, until every behaviour in the Destination is real and tested. Then call the Skill tool with "code-review" over the whole diff and fix what it finds. Do not hand off to `/to-spec`, `/to-tickets`, or `/implement`: this variant carries execution into the map by design.
7. **Close the map.** Record what was built in a final comment on the map (the feature, the tests, the review verdict), close it, and link the pull request or branch. The only deliverable is the full feature, not a spec.

## Refer by name

Every map and ticket is an issue, so it has a **name**: its title. In everything the human reads (narration, the map's Decisions-so-far), refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish; a name wraps its link, but they ride _inside_ the name, never stand in for it.

Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=implement
```

```bash
npx skills update implement
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/implement)

## What it does

`implement` builds the work described in a spec or a set of tickets — driving it through test-driven development, typechecking, and the full test suite, then handing off to review and committing to the current branch.

It does **not** decide what to build. The spec is already settled and the seams are already agreed; `implement` executes that plan rather than reopening it. It is the hands, not the head — the thinking happened upstream.

## When to reach for it

You invoke this by typing `/implement` — the agent won't reach for it on its own.

Reach for it once the work is written down as a spec or split into tickets and you're ready to turn that into code. If the spec doesn't exist yet, write it first — for that, use [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md), or [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md) to break a spec into tickets. If you just want to build something test-first without a full spec, drop to [tdd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/tdd/SKILL.md) directly.

## Pre-agreed seams

The idea `implement` runs on is the **seam** — the stable interface a feature is tested at, chosen before any code is written. It doesn't invent seams mid-build; it uses the ones already picked (during [to-spec](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-spec/SKILL.md)) and writes tests against them via [tdd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/tdd/SKILL.md). Working at pre-agreed seams is what keeps the implementation honest: the tests target something durable, so the code underneath can move without the tests moving.

Around that core it keeps the loop tight — typecheck often, run single test files as it goes, run the whole suite once at the end — then closes out with a review pass and a commit to the current branch.

## Where it fits

`implement` is the build step near the end of the main chain, just before the review:

```txt
grill-with-docs → to-spec → to-tickets → implement → code-review
```

Reach for it after the work has been specced and sequenced, not before. Its key neighbours are [to-tickets](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/to-tickets/SKILL.md), which produces the tickets — each declaring its blocking edges — that it works through, and [tdd](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/tdd/SKILL.md), which it drives internally to write the tests at each seam before running its own [code-review](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/code-review/SKILL.md) pass and committing. When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

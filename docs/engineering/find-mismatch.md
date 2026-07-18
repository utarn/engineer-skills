Quickstart:

```bash
npx skills add utarn/engineer-skills --skill=find-mismatch
```

```bash
npx skills update find-mismatch
```

[Source](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/find-mismatch)

## What it does

`find-mismatch` is a code review that hunts only for bugs that break at runtime — contract mismatches, logic and async errors, serialization/casing bugs, null derefs, and styling failures like raw-HSL Tailwind v4 breakages — plus a JS/TS static-analysis pass via `fallow`. It deliberately ignores style, formatting, performance suggestions, docs/tests, and "consider using X" nags. The defining constraint: it reports only things that would actually crash or misbehave when the code runs.

For JS/TS projects it runs `fallow audit` first, filtered to your staged files, auto-applying safe fixes when the files are staged and reporting only when they are not. Then it walks every changed file against a fixed checklist of runtime-failure categories.

## When to reach for it

You invoke this by typing `/find-mismatch` — the agent won't reach for it on its own.

Reach for it when you want a focused bug hunt on a diff, not the full two-axis Standards/Spec review. For the broader review that also checks conformance to repo standards and faithfulness to the originating spec, use [code-review](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/code-review/SKILL.md) instead. `find-mismatch` is the narrower lens for the times you specifically want runtime-breaking bugs and static-analysis findings called out.

## Prerequisites

For the `fallow` pre-check on JS/TS projects, it installs `fallow` globally if missing (`npm install -g fallow`) and runs `fallow audit`. Non-JS/TS projects skip that step and go straight to the manual checklist — no setup needed.

## The runtime-bug lens

The defining idea is the **runtime failure**. The checklist is fixed across seven categories — cross-boundary contracts, serialization/deserialization, logic bugs, property/method access, async/concurrency, CSS/styling, and placeholder/stub code — each naming the specific shape of bug that breaks when the code runs (a `userId`/`user_id` casing mismatch across an RPC boundary; a `page <= total` off-by-one; a missing `await` on a promise). Language-specific pitfalls (Python mutable defaults, Rust `unwrap()` on `None`, Go map-concurrent-access, PHP loose comparisons, etc.) layer on top. Findings are reported with file, category, runtime effect, and fix — never as style nags.

## It's working if

- It runs `fallow audit` first on JS/TS projects, auto-applying fixes only to staged files and report-only on unstaged ones.
- Every reported finding is a runtime breaker — contract mismatch, logic bug, null deref, serialization failure — not a style or performance suggestion.
- Findings cite file and line, name the category, state the runtime effect, and give a fix; `fallow`-sourced findings are tagged `[fallow]`.

## Where it fits

`find-mismatch` is a **reach-for-it-anytime standalone** review — the narrower sibling of [code-review](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/code-review/SKILL.md). Where `code-review` runs two axes (Standards + Spec) at the end of the build chain, `find-mismatch` is the bug-only lens you reach for mid-build or on a focused diff. When you're unsure which skill or flow fits, [ask-utarn](https://github.com/utarn/engineer-skills/tree/main/skills/engineering/ask-utarn/SKILL.md) routes you.

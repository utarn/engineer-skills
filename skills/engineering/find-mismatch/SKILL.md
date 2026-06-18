---
name: find-mismatch
effort: high
description: >
  Systematic code review focusing on bugs that break at runtime (contract mismatches, logic/async errors, serialization, styling) and JS/TS static analysis via fallow.
disable-model-invocation: true
---

# Find Mismatch

Walk through every file. Focus only on runtime failures/bugs. Do NOT report style, formatting, performance suggestions, docs/tests, or "consider using X".

## 1. Process
1. **JS/TS (Pre-check)**: Run static analysis.
   - Check if installed: `fallow --version`.
   - Install globally if missing: `npm install -g fallow`.
   - Execute audit: `fallow audit --format json --quiet`.
   - Filter findings by git status: `git diff --staged --name-only`.
   - If staged: auto-apply safe fixes, re-run audit to verify.
   - If unstaged: report-only (no modification).
2. **Review Checklist**: Apply checklist to all changes.
3. **Report**: Format findings using the specified template.

---

## 2. Checklist Categories

### 1. Cross-Boundary Contracts
- Calling mismatch: Check RPC, HTTP, IPC, event name/subject match receiver.
- Param names/types: `userId` vs `user_id`, string vs number, flat vs wrapped.
- Return type: Field accesses (`result.field`) must match return signature.

### 2. Serialization & Deserialization
- Casing: `snake_case` in DB/backend vs `camelCase` in JSON/frontend.
- Optionals: Field expected by receiver but optional in producer.
- Enums/discriminators: Discriminant fields (`type`, `kind`) and variants match.
- Base64: Double-encoding layers.

### 3. Logic Bugs
- Double counting: Counters incremented both in loop/branch and outside.
- Off-by-one: Index, pagination bounds (`page <= total` vs `page < total`).
- Conditions: Redundant/dead flags, unreachable statements, shadowed variables.

### 4. Property & Method Access
- Null derefs: Method calls or array index access (`items[0].name`) without null/length checks.
- Optional chaining: Stop check too early (e.g. `user?.address.street` still crashes if `address` is null).
- This context: Callback bindings in classes.

### 5. Async & Concurrency
- Race conditions: Shared mutable states, parallel filesystem accesses without coordination.
- Missing `await`: Promise ignored, silent errors.
- Leaks: File/DB/network connections not closed in error paths.

### 6. CSS & Styling
- HSL variables: Raw HSL components (`0 0% 100%`) instead of functional format (`hsl(0 0% 100%)`) fail in Tailwind v4 (unlike v3).
- Inline themes: Circular references, selector mismatch (class vs data-theme).

### 7. Placeholder & Stub Code
- Unused declarations/files/dependencies, TODO comments, empty catch blocks.

---

## 3. Language-Specific Pitfalls

- **Python**: Hallucinated library methods (pandas, numpy, requests), sync/asyncio confusion, mutable default arguments (`def f(x=[])`), silent indentation drops.
- **JS/TS**: Backend (Node) vs Frontend (Browser) API mix-ups, `any` abuse, type-only import mismatches, barrel file false positives (exported but unused in production, used in tests/libraries).
- **C++**: Raw vs smart pointer mix-ups, missing standard library header `#include`, uninitialized variables, buffer overflows.
- **Rust**: Borrow checker lifetime overcomplication, `unwrap()` on `None`/`Err`, locking across `.await` yield points.
- **Java / .NET**: Hallucinated annotations/attributes, LINQ N+1 queries, Entity Framework model snapshot drift / missing migrations (check model changes under `Entities/` against `Migrations/`).
- **Go**: WaitGroup/Channel deadlocks, unexported struct fields in JSON, defer in loop, map concurrent access.
- **PHP**: Loose type comparisons (`==` vs `===`), array vs object access, key undefined.

---

## 4. Fallow Finding Mapping & Fixes

| Fallow Type | Checklist Category | Auto-Fix Action |
|---|---|---|
| `unused_exports` | Placeholder & Stub | Remove `export` (if used locally) or entire declaration. |
| `unused_files` | Placeholder & Stub | Delete file (check dynamic imports first). |
| `unused_dependencies` | Placeholder & Stub | Remove dependency from `package.json`. |
| `circular_dependencies`| Cross-Boundary | Defer to manual review (causes init bugs). |
| `complexity`/`duplication` | Logic Bugs | Defer to manual review. |

---

## 5. Output Format

Include `## Review Summary` header (only if JS/TS project):
```
## Review Summary
- **Manual review bugs found**: N
- **Fallow auto-fixed**: N findings (staged files only)
- **Fallow non-auto-fixable**: N findings
- **Fallow verdict**: pass / fail
```

Format individual findings (add `[fallow]` tag for fallow-sourced bugs):
```
## Bug #1
- **File**: <path>:<line>
- **Category**: <category>
- **What's wrong**: <description>
- **Runtime effect**: <effect>
- **Fix**: <code>
```

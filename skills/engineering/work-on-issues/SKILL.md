---
name: work-on-issues
effort: max
model: sonnet
description: >
  Fetch, implement, and close GitHub/GitLab issues sequentially (one main issue starting with PRD:/feat: at a time). Handles parallel subtasks, dependency parsing, worktrees, and env propagation.
---

# Work on Issues

Fetches GitHub/GitLab issues, triages, implements sequentially (one main issue at a time) using git worktree and subagent, runs `find-mismatch` reviews, and closes.

## 1. Tracker Setup
Detect host via `git remote -v`. Set `$TRACKER` to `gh` or `glab`.
Terminologies:
- GitHub: `pr` / `comment`
- GitLab: `mr` / `note`

---

## 2. Phase 1: Fetch & Triage
1. **List open issues**: Use `gh issue list --state open --json number,title,labels` or `glab issue list -O json`.
2. **Filter**: Keep only main issues (title starts with `PRD:` or `feat:`). Others are skipped for auto/batch runs (but allowed if explicitly picked).
3. **Choice**: User selects issue number or onwards mode.
4. **Pre-checks**:
   - Verify open (Skip if closed).
   - Detect PRD/Epic by label `PRD` or title prefix `PRD:`. Skip implementation, add to `$PRD_TRACKER` for auto-close check.
5. **Read Details**: Fetch full issue view and comments (`gh issue view --comments` / `glab issue view --comments`).
6. **Assign & Label**: Mark `in-progress` (by applying `in-progress` label and removing `ready-for-agent` and `needs-triage`).

---

## 3. Dependencies & Linking
Parse `## Blocked by` in issue body (matches `#42` or full issue URL) to build `DEPS[issue] = [blockers]`.
If possible, create native tracker links (e.g., GitLab API `/links` with `is_blocked_by` or GitHub sub-issues API with `blocked_by=true`). Fall back to text references.

---

## 4. Phase 2: Implement (One Main Issue at a Time)
1. **Create Worktree**:
   ```bash
   git worktree add .claude/worktrees/issue-<number> -b work-on-issue-<number>
   ```
2. **Copy `.env` files**: Copy `.env` and `.env.*` files into worktree directory.
3. **Dispatch Sub-Agent using haiku model** (`subagent_type: "full-stack-engineer"` inside `.claude/worktrees/issue-<number>`): 
   Prompt spec:
   ```markdown
   Implement issue #<number>: <title>.
   Acceptance Criteria: <AC>
   Branch/Worktree: work-on-issue-<number> in .claude/worktrees/issue-<number>
   API/best-practices: Search via `context7`, `/brightdata-plugin:search`, `/search`, or WebSearch before writing code if unsure.
   Stuck on errors: If 2+ consecutive failures, you MUST research via `context7`, `/brightdata-plugin:search`, `/search`, or WebSearch first (they are available) to find the correct API/approach, then retry. Only escalate after researching.
   Parallel subtasks: Decompose & dispatch sub-agents if tasks are independent (no shared files/dirs).
   Post-implementation: Check output, diff, and run tests and run `find-mismatch` skill on modified files only. If the programming language is typescript or javascript, run `npx fallow audit` (Make sure to install `fallow` if not present). If errors, fix and re-run tests.
   Output: Summary, find-mismatch fixes, tests run, and commit hash.
   Commit format: `fix: resolve #<number> — <short description>`
   ```
4. **Commit**: Ensure changes are committed in worktree (`fix: resolve #<number> — <desc>`).

---

## 5. Phase 3: Submit & Close
1. **Create PR/MR**: Link to issue using "Closes #<number>".
2. **Auto-Merge**: Merge immediately (squash & delete branch).
3. **Comment**: Post summary of implementation.
4. **Close**: Remove triage/progress labels (like `in-progress`), add `closed`, and close issue.
5. **Propagate `.env` files**: Copy modified env files back to main working directory before worktree removal:
   ```bash
   WT=.claude/worktrees/issue-<number>
   for wtf in "$WT"/.env "$WT"/.env.*; do
     [ -f "$wtf" ] || continue
     base=$(basename "$wtf")
     if [ ! -f "$base" ] || ! cmp -s "$base" "$wtf"; then
       cp "$wtf" "$base" && echo "Propagated $base back"
     fi
   done
   ```
6. **Clean up**:
   ```bash
   git worktree remove .claude/worktrees/issue-<number>
   git branch -d work-on-issue-<number>
   ```

---

## 6. PRD Auto-Close
After closing a sub-issue, check all PRDs in `PRD_TRACKER`. Read PRD description/links. If all referenced sub-issues (`#42` etc.) are closed, close the PRD and remove from `PRD_TRACKER`.

---

## 7. Subtask Parallelization
Decompose main issue into subtasks if:
- Touch non-overlapping files/folders.
- Independent outputs (no order dependency).
Keep sequential if they share files, have strict flow dependencies, or need configuration first.

### Subtask Prompt Spec:
```markdown
Implement subtask for issue #<number>: <title>.
Subtask: <details>
Working Directory: .claude/worktrees/issue-<number>
Scope: Modify <MAY_MODIFY>, DO NOT modify <MUST_NOT_MODIFY>.
Compile/Lint errors: If 2+ consecutive failures, you MUST research via `context7`, `/brightdata-plugin:search`, `/search`, or WebSearch first (they are available). Check Reference Directories (<RefDirs>) to align configurations.
Post-implementation: Run `find-mismatch` on modified files, auto-fix.
Verification: Run relevant tests. Return summary, modified files, test results.
```

---

## 8. Execution Modes

### Batch & Onwards Mode
1. Fetch all open issues, filter to main issues (`PRD:`, `feat:`).
2. Parse `DEPS` map from issue bodies, set formal links.
3. Show progress table: `| Issue | Title | Type | Blocked By | Agent | Status | PR/MR |`
4. **Loop**:
   - Select next issue with zero unresolved blockers. Skip closed or PRD issues.
   - Dispatch sub-agent to worktree.
   - Run verification -> PR/MR merge -> close -> env propagation -> clean up -> check PRDs.
   - Re-evaluate dependencies. Repeat.
5. Re-fetch all open issues after finishing (Outer loop) to pick up new main issues. Exit only if no open main issues remain or user interrupts.

### Single Issue Mode
Execute the selected issue solo. Skip dependency graph processing.

---

## 9. Labels & Helpers

| Label | Meaning | Color |
|---|---|---|
| `PRD` | Parent tracking issue | `#0075CA` |
| `in-progress` | Active | `#E4E669` |
| `ready-for-agent` | Ready for agent | `#0E8A16` |
| `closed` | Closed by AI / Finished | `#5319E7` |

To apply labels, try updating directly. If not found, create label first (e.g. color `#E4E669` for `in-progress`) and retry.

---

## 10. Edge Cases
- **No CLI**: Use APIs directly or ask user to install `gh`/`glab`.
- **Conflict/Cycle**: Report circular dependencies, skip affected issues.
- **External Blockers**: Treat open external issues as unresolved blockers.
- **API Link Failure**: Fall back to text references.
- **No Main Issues**: Inform user, ask if they want to process non-main issues.
- **Env files gitignored**: Env files must be propagated back before worktree removal to persist across runs. Do not commit secrets.

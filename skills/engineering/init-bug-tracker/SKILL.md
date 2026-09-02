---
name: init-bug-tracker
description: Initialize or re-sync the label taxonomy on a public GitHub bug tracker, and record the tracker in this repo's agent config. Run once per tracker repo.
disable-model-invocation: true
---

# Init Bug Tracker

Create the label taxonomy that the public bug-tracker workflow needs, then record the tracker so `/bug-tracker` finds it without asking again.

A **bug tracker** is a public GitHub repo — separate from your source code — where users and testers file bug reports, feedback, and feature requests against a shipped product. It holds reports, not source. The taxonomy below is what `/bug-tracker` drives issues through; `/triage`'s five canonical roles are a subset of it, so a tracker initialized here also works for triage flows.

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated (`gh auth status`).
- Permission to manage labels on the target repo.

## 1. Resolve the tracker repo

In order:

1. An explicit argument: `/init-bug-tracker <owner/repo>`.
2. A tracker already recorded for this repo — the `### Bug tracker` sub-block under `## Agent skills` in `CLAUDE.md` or `AGENTS.md`.
3. Ask the maintainer which repo should receive public reports.

Check the repo is reachable before touching it: `gh repo view <owner/repo>`.

## 2. Derive the area labels

Four of the five label groups are identical across every project — they encode the workflow. The fifth, `area:*`, describes the *product*, so derive it rather than copying anyone's list:

1. Read the source repo — its README, top-level directory layout, and `CONTEXT.md` if one exists — and propose 4–8 components, each as `area:<kebab-slug>` with a one-line description and its own distinct colour.
2. Present the proposal; the maintainer confirms, edits, or replaces it.
3. If the tracker covers a product whose code is not in this working directory, ask the maintainer for the component list instead.

Shape of a good set (a PDF editor): `area:pdf-editor`, `area:annotations`, `area:ocr`, `area:export-import`, `area:license`, `area:ui-ux`.

## 3. Create the labels

Run the script below with `gh label create --force`. `--force` is idempotent — new labels are created, existing ones overwritten with the correct colour and description, nothing is deleted — so re-running is safe whenever the taxonomy drifts.

```bash
REPO="<owner/repo>"

fixed=(
  # 1. Triage & state — the workflow /bug-tracker drives
  "needs-triage|ededed|Maintainer needs to evaluate this issue"
  "needs-info|d93f0b|Waiting on reporter/tester for more information or feedback"
  "ready-for-agent|0e8a16|Fully specified, ready for an AFK agent to implement"
  "ready-for-human|fbca04|Requires human developer action, manual testing, or design decisions"
  "in-progress|1d76db|Currently being investigated or worked on"
  "resolved|006b75|Resolved or implemented, awaiting reporter/tester verification"
  "wontfix|ffffff|Will not be actioned or out of scope"

  # 2. Type & category
  "bug|d73a4a|Something isn't working as expected"
  "enhancement|a2eeef|New feature or improvement request"
  "feedback|c2e0c6|User or tester feedback and suggestions"
  "documentation|0075ca|Documentation, guide, or translation issue"
  "question|d876e3|Question or usage inquiry"

  # 3. Priority & severity
  "priority:critical|b60205|Severe blocker, crash, or data loss"
  "priority:high|d93f0b|High impact issue affecting major functionality"
  "priority:medium|fbca04|Standard priority issue"
  "priority:low|c5def5|Minor issue, cosmetic defect, or low priority"

  # 4. Verification & testing
  "tester-verified|0e8a16|Verified and reproduced by QA/tester"
  "needs-reproduction|e11d48|Cannot reproduce yet, reproduction steps required"
)

# 5. Domain areas — one line per area confirmed in step 2:
#    "area:<slug>|<hex>|<description>"
areas=(
  "area:example-one|5319e7|Replace with the areas derived in step 2"
)

for item in "${fixed[@]}" "${areas[@]}"; do
  IFS="|" read -r name color desc <<< "$item"
  gh label create "$name" --description "$desc" --color "$color" --force -R "$REPO"
done
```

## 4. Initialize Issue Templates & README

Set up standard GitHub Issue Forms (`.github/ISSUE_TEMPLATE/`) and `README.md` on the tracker repository so users and testers can file structured bug reports and feature requests.

Generate and push the following templates to the tracker repo:

### A. Bug Report Template (`.github/ISSUE_TEMPLATE/bug_report.yml`)
Includes structured fields tailored to the product:
- App Version input
- Operating System dropdown (macOS Apple Silicon / Intel, Windows 11 / 10, Linux, etc.)
- Component Area dropdown populated with the `area:*` tags derived in Step 2
- Bug description and step-by-step reproduction instructions
- Expected vs. Actual behavior
- Monospace shell block for DevTools console logs / error stack traces
- Drag-and-drop attachments box for screenshots, screen recordings, and sample files

### B. Feature Request Template (`.github/ISSUE_TEMPLATE/feature_request.yml`)
Includes problem statement, proposed solution, component area dropdown, alternatives considered, and mockup uploads.

### C. Issue Template Config (`.github/ISSUE_TEMPLATE/config.yml`)
Configures the issue chooser links and disables unguided blank issues (`blank_issues_enabled: false`).

### D. README (`README.md`)
Explains the purpose of the tracker, links to new issue forms, and documents the triage labels and security/privacy guidance.

### Script to Apply Templates to Target Repo:

```bash
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
git clone "https://github.com/$REPO.git" . || { git init && git branch -M main && git remote add origin "https://github.com/$REPO.git"; }
mkdir -p .github/ISSUE_TEMPLATE

# Write .github/ISSUE_TEMPLATE/config.yml, bug_report.yml, feature_request.yml, and README.md
# (Populate area options using the derived areas)

git add .
git commit -m "feat: initialize issue templates and tracker guide" || true
git push -u origin main
rm -rf "$TMP_DIR"
```

## 5. Record the tracker

So future runs of `/bug-tracker` resolve the tracker without asking, add (or update in place) this sub-block under the `## Agent skills` section of `CLAUDE.md` or `AGENTS.md` — edit whichever of the two already exists; ask which to create if neither does:

```markdown
### Bug tracker

Public reports for this product are filed at <owner/repo>. Triaged by `/bug-tracker`; taxonomy maintained by `/init-bug-tracker`.
```

## 6. Verify

1. Run `gh label list -R "$REPO" --limit 200` to verify all labels.
2. Check that issue forms are available at `https://github.com/<owner/repo>/issues/new/choose`.
3. Report the full setup status back to the maintainer.

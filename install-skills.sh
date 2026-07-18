#!/usr/bin/env bash
# Clone the engineer-skills repo and install all skills into
# ~/.agents/skills/ and ~/.claude/skills/.

set -euo pipefail

REPO_URL='https://github.com/utarn/engineer-skills.git'
SKILLS_SRC="${HOME}/engineer-skills/skills"

# ── Prepare destination directories ────────────────────────────────────────
for dir in "$HOME/.agents/skills" "$HOME/.claude/skills"; do
    mkdir -p "$dir"
done

# ── Clone the repo ────────────────────────────────────────────────────────
if [ ! -d "$SKILLS_SRC" ]; then
    echo "Cloning $REPO_URL ..."
    git clone --depth 1 --quiet "$REPO_URL" "${SKILLS_SRC%/*}"
    if [ ! -d "$SKILLS_SRC" ]; then
        echo "Failed to clone repository." >&2
        exit 1
    fi
fi

# ── Copy each skill ─────────────────────────────────────────────────────
count=0
for skill in "$SKILLS_SRC"/*/; do
    if [ -d "$skill" ]; then
        cp -R "$skill" "$HOME/.agents/skills/"
        cp -R "$skill" "$HOME/.claude/skills/"
        echo "Installed $(basename "$skill" /)"
        count=$((count + 1))
    fi
done

# ── Cleanup ───────────────────────────────────────────────────────────────
rm -rf "${SKILLS_SRC%/*}"

echo "Done. $count skill(s) installed."
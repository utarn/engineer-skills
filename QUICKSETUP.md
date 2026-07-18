# Quick Setup

Get Claude Code working with all the tools you need in one shot: the engineer-skills plugin, Context7 for live docs, and the brightdata web-scraping skill.

Pick your shell and run the **install** block once. That gives you a `ccc` / `cccc` pair to launch Claude Code, plus a `quicksetup` function that wires up the skills. Then just type `quicksetup` to run it.

> `ccc` and `cccc` are convenience wrappers around `claude` — they skip the per-command permission prompt and continue the last session, matching the `--dangerously-skip-permissions` flow the rest of this repo assumes. They call `claude` directly, so they work for anyone, not just the author's private aliases.

## Bash (Linux / macOS)

Add this to `~/.bashrc` (or `~/.zshrc` on macOS), then start a new shell:

```bash
# Convenience launchers for Claude Code
ccc()  { claude --dangerously-skip-permissions "$@"; }
cccc() { claude --dangerously-skip-permissions --continue "$@"; }

# One-shot setup: engineer-skills plugin + Context7 + brightdata skill
quicksetup() {
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn
  npx ctx7@latest setup
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

Run it:

```bash
quicksetup
```

## PowerShell (Windows)

Add this to your PowerShell profile (`notepad $PROFILE`), then open a new terminal:

```powershell
# Convenience launchers for Claude Code
function ccc  { claude --dangerously-skip-permissions @args }
function cccc { claude --dangerously-skip-permissions --continue @args }

# One-shot setup: engineer-skills plugin + Context7 + brightdata skill
function quicksetup {
  claude plugin marketplace add utarn/engineer-skills
  claude plugin install utarn-skills@utarn
  npx ctx7@latest setup
  claude plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

Run it:

```powershell
quicksetup
```

## What each step does

| Step | Command | Effect |
|---|---|---|
| 1 | `claude plugin marketplace add utarn/engineer-skills` | Register this repo as a Claude Code plugin marketplace. |
| 2 | `claude plugin install utarn-skills@utarn` | Install the whole engineer-skills bundle as a managed, auto-updating plugin. |
| 3 | `npx ctx7@latest setup` | Install Context7 into your coding agent so it can fetch live library docs. |
| 4 | `claude plugin install brightdata-plugin@claude-plugins-official --scope local` | Add the brightdata web-scraping skill to this project. |

After `quicksetup` finishes, run `/setup-utarn-skills` once per repo to configure issue tracker, triage labels, and docs location — see the [Quickstart](./README.md#quickstart-30-second-setup) in the README.

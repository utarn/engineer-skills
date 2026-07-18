# Quick Setup

Get Claude Code working with all the tools you need in one shot.

Run the setup function for your shell. It will:
- Add the engineer-skills plugin to Claude Code's plugin marketplace
- Install the `utarn-skills` plugin from the `utarn` publisher
- Run `npx ctx7 setup` to install Context7
- Install the brightdata skill

## Bash

```bash
quicksetup() {
  ccc plugin marketplace add utarn/engineer-skills
  cccc plugin install utarn-skills@utarn
  npx ctx7 setup
  # Install brightdata skill
  ccc plugin install brightdata-plugin@claude-plugins-official --scope local
}
```

## PowerShell

```powershell
function QuickSetup {
  ccc plugin marketplace add utarn/engineer-skills
  cccc plugin install utarn-skills@utarn
  npx ctx7 setup
  # Install brightdata skill
  ccc plugin install brightdata-plugin@claude-plugins-official --scope local
}
```
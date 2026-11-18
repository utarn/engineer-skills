#Requires -Version 5.1
<#
.SYNOPSIS
    Clone the engineer-skills repo and install all skills into
    ~/.agents/skills/ and ~/.claude/skills/.
#>

$ErrorActionPreference = 'Stop'

$REPO_URL = 'https://github.com/utarn/engineer-skills.git'
$SKILLS_SRC = Join-Path $env:USERPROFILE 'engineer-skills/skills'

# ── Prepare destination directories ────────────────────────────────────────
$agentsSkills = Join-Path $env:USERPROFILE '.agents/skills'
$claudeSkills = Join-Path $env:USERPROFILE '.claude/skills'

foreach ($dir in @($agentsSkills, $claudeSkills)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force | Out-Null
    }
}

# ── Clone the repo ────────────────────────────────────────────────────────
if (-not (Test-Path $SKILLS_SRC)) {
    Write-Host "Cloning $REPO_URL ..."
    git clone --depth 1 --quiet "$REPO_URL" (Split-Path $SKILLS_SRC) 2>&1
    if (-not (Test-Path $SKILLS_SRC)) {
        Write-Error "Failed to clone repository."
        exit 1
    }
}

# ── Copy each skill ──────────────────────────────────────────────────────
$skillDirs = Get-ChildItem -Path $SKILLS_SRC -Directory
foreach ($skill in $skillDirs) {
    $src = Join-Path $SKILLS_SRC $skill.Name
    foreach ($dst in @($agentsSkills, $claudeSkills)) {
        Copy-Item -Path $src -Destination $dst -Recurse -Force
    }
    Write-Host "Installed $($skill.Name)"
}

# ── Cleanup ───────────────────────────────────────────────────────────────
Remove-Item -Path $SKILLS_SRC -Recurse -Force 2>$null

Write-Host "Done. $($skillDirs.Count) skill(s) installed."
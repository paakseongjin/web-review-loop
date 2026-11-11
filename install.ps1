# Install the web-review-loop skill into a project (Windows).
# Usage: .\install.ps1 C:\path\to\project [claude|cursor|both]   (default: both)
param(
  [Parameter(Mandatory=$true)][string]$Target,
  [ValidateSet("claude", "cursor", "both")][string]$Mode = "both"
)
$ErrorActionPreference = "Stop"
$Src = Split-Path -Parent $MyInvocation.MyCommand.Path
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
function Install-Skill([string]$Dest) {
  if (Test-Path $Dest) {
    Rename-Item $Dest "$Dest.bak-$Stamp"
    Write-Host "backed up existing: $Dest.bak-$Stamp"
  }
  New-Item -ItemType Directory -Force -Path (Split-Path $Dest) | Out-Null
  Copy-Item -Recurse (Join-Path $Src "skills\web-review-loop") $Dest
  Write-Host "installed skill -> $Dest"
}
if ($Mode -eq "claude" -or $Mode -eq "both") {
  Install-Skill (Join-Path $Target ".claude\skills\web-review-loop")
}
if ($Mode -eq "cursor" -or $Mode -eq "both") {
  Install-Skill (Join-Path $Target ".cursor\skills\web-review-loop")
  $RulesDir = Join-Path $Target ".cursor\rules"
  New-Item -ItemType Directory -Force -Path $RulesDir | Out-Null
  $RuleDest = Join-Path $RulesDir "web-review-guardrails.mdc"
  if (Test-Path $RuleDest) { Rename-Item $RuleDest "$RuleDest.bak-$Stamp" }
  Copy-Item (Join-Path $Src "cursor\web-review-guardrails.mdc") $RuleDest
  Write-Host "installed cursor rule -> $RuleDest"
}
Write-Host "done. Run /web-review-loop in Claude Code or Cursor Agent chat."

#!/usr/bin/env bash
# web-review-loop project gate: runs the project's own checks.
# Missing tool/script = SKIPPED, never PASS. Installs nothing.
# Usage: bash web-gate.sh [project-dir]
set -u
cd "${1:-.}" || exit 2
PASS=0; FAIL=0; SKIP=0; declare -a ROWS=()
run_check() {
  local name="$1"; shift; local cmd_str="$1"; shift
  if ! command -v "$1" >/dev/null 2>&1; then
    ROWS+=("| $name | SKIPPED | - | tool not found: $1 |"); SKIP=$((SKIP+1)); return
  fi
  local out rc; out="$("$@" 2>&1)"; rc=$?
  if [ $rc -eq 0 ]; then ROWS+=("| $name | PASS | $rc | \`$cmd_str\` |"); PASS=$((PASS+1));
  else ROWS+=("| $name | FAIL | $rc | \`$cmd_str\` |"); FAIL=$((FAIL+1));
    echo "----- FAIL output: $name -----"; echo "$out" | tail -n 30; echo "-------------------------------"; fi
}
echo "== web-review gate: $(pwd) =="
if [ -f package.json ] && command -v node >/dev/null 2>&1; then
  PM="npm"; [ -f pnpm-lock.yaml ] && PM="pnpm"; [ -f yarn.lock ] && PM="yarn"; [ -f bun.lockb ] && PM="bun"
  for s in build lint test; do
    if node -e "process.exit((require('./package.json').scripts||{})['$s']?0:1)" 2>/dev/null; then
      if [ "$s" = "test" ]; then run_check "tests" "$PM test" $PM test; else run_check "$s" "$PM run $s" $PM run $s; fi
    else
      ROWS+=("| $s | SKIPPED | - | no $s script in package.json |"); SKIP=$((SKIP+1))
    fi
  done
  [ -d node_modules/typescript ] && run_check "types" "npx tsc --noEmit" npx tsc --noEmit
fi
run_check "secrets" "gitleaks detect --no-banner" gitleaks detect --no-banner
echo; echo "| Check | Result | Exit | Command |"; echo "|---|---|---|---|"
for r in "${ROWS[@]}"; do echo "$r"; done
echo; echo "Summary: PASS=$PASS FAIL=$FAIL SKIPPED=$SKIP"
[ $FAIL -eq 0 ]

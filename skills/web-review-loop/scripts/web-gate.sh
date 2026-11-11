#!/usr/bin/env bash
# Project checks; inspect scripts for external side effects before running.
# Output is suppressed because it can include secrets or personal data.
# Exit 0: at least one check ran and none failed; 1: failure; 2: none ran.
set -u
cd "${1:-.}" || exit 2
PASS=0; FAIL=0; SKIP=0; declare -a ROWS=()
skip_check() { ROWS+=("| $1 | SKIPPED | $2 |"); SKIP=$((SKIP+1)); }
run_check() {
  local name="$1"; shift; local cmd_str="$1"; shift
  if ! command -v "$1" >/dev/null 2>&1; then
    skip_check "$name" "tool unavailable"; return
  fi
  local rc=0
  "$@" >/dev/null 2>&1 || rc=$?
  if [ "$rc" -eq 0 ]; then
    ROWS+=("| $name | PASS | $cmd_str |"); PASS=$((PASS+1))
  else
    ROWS+=("| $name | FAIL | exit $rc; output suppressed |"); FAIL=$((FAIL+1))
  fi
}
if [ -f package.json ] && command -v node >/dev/null 2>&1; then
  PM="npm"; [ -f pnpm-lock.yaml ] && PM="pnpm"; [ -f yarn.lock ] && PM="yarn"; { [ -f bun.lockb ] || [ -f bun.lock ]; } && PM="bun"
  for s in build lint test; do
    if node -e "process.exit((require('./package.json').scripts||{})['$s']?0:1)" >/dev/null 2>&1; then
      if [ "$s" = "test" ]; then run_check "tests" "$PM test" "$PM" test; else run_check "$s" "$PM run $s" "$PM" run "$s"; fi
    else
      skip_check "$s" "no script"
    fi
  done
  if [ -f node_modules/typescript/bin/tsc ]; then
    run_check "types" "node node_modules/typescript/bin/tsc --noEmit" node node_modules/typescript/bin/tsc --noEmit
  else
    skip_check "types" "local TypeScript unavailable"
  fi
else
  for s in build lint tests types; do skip_check "$s" "package.json or Node unavailable"; done
fi
run_check "secrets" "gitleaks detect --no-banner" gitleaks detect --no-banner
echo "| Check | Result | Detail |"; echo "|---|---|---|"
for r in "${ROWS[@]}"; do echo "$r"; done
echo "Summary: PASS=$PASS FAIL=$FAIL SKIPPED=$SKIP"
echo "Command output suppressed; inspect diagnostics locally with care. Results cover only checks that ran."
if [ "$FAIL" -gt 0 ]; then exit 1; fi
if [ "$PASS" -eq 0 ]; then exit 2; fi
exit 0

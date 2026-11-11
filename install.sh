#!/usr/bin/env bash
# Install the web-review-loop skill into a project.
# Usage: bash install.sh /path/to/project [claude|cursor|both]   (default: both)
# Existing installs are backed up to <name>.bak-YYYYMMDD-HHMMSS.
set -eu
SRC="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:?usage: install.sh /path/to/project [claude|cursor|both]}"
MODE="${2:-both}"
case "$MODE" in claude|cursor|both) ;; *) echo "Invalid mode: use claude, cursor, or both" >&2; exit 2 ;; esac
STAMP="$(date +%Y%m%d-%H%M%S)"
install_skill() {
  local dest="$1"
  if [ -e "$dest" ]; then mv "$dest" "$dest.bak-$STAMP"; echo "backed up existing: $dest.bak-$STAMP"; fi
  mkdir -p "$(dirname "$dest")"
  cp -R "$SRC/skills/web-review-loop" "$dest"
  echo "installed skill -> $dest"
}
case "$MODE" in claude|both) install_skill "$TARGET/.claude/skills/web-review-loop" ;; esac
case "$MODE" in
  cursor|both)
    install_skill "$TARGET/.cursor/skills/web-review-loop"
    mkdir -p "$TARGET/.cursor/rules"
    if [ -e "$TARGET/.cursor/rules/web-review-guardrails.mdc" ]; then
      mv "$TARGET/.cursor/rules/web-review-guardrails.mdc" "$TARGET/.cursor/rules/web-review-guardrails.mdc.bak-$STAMP"
    fi
    cp "$SRC/cursor/web-review-guardrails.mdc" "$TARGET/.cursor/rules/web-review-guardrails.mdc"
    echo "installed cursor rule -> $TARGET/.cursor/rules/web-review-guardrails.mdc"
    ;;
esac
echo "done. Run /web-review-loop in Claude Code or Cursor Agent chat."
echo "tip: node skills static check works anywhere: node .claude/skills/web-review-loop/scripts/static-check.mjs <site-dir>"

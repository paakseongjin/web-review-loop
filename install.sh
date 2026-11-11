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
  local dest="$1" name="$2"
  if [ -e "$dest" ]; then mv "$dest" "$dest.bak-$STAMP"; echo "backed up existing: $dest.bak-$STAMP"; fi
  mkdir -p "$(dirname "$dest")"
  cp -R "$SRC/skills/$name" "$dest"
  echo "installed skill -> $dest"
}
case "$MODE" in claude|both) for name in web-review-loop web-review-experience web-review-code web-review-measurement; do install_skill "$TARGET/.claude/skills/$name" "$name"; done ;; esac
case "$MODE" in
  cursor|both)
    for name in web-review-loop web-review-experience web-review-code web-review-measurement; do install_skill "$TARGET/.cursor/skills/$name" "$name"; done
    mkdir -p "$TARGET/.cursor/rules"
    if [ -e "$TARGET/.cursor/rules/web-review-guardrails.mdc" ]; then
      mv "$TARGET/.cursor/rules/web-review-guardrails.mdc" "$TARGET/.cursor/rules/web-review-guardrails.mdc.bak-$STAMP"
    fi
    cp "$SRC/cursor/web-review-guardrails.mdc" "$TARGET/.cursor/rules/web-review-guardrails.mdc"
    echo "installed cursor rule -> $TARGET/.cursor/rules/web-review-guardrails.mdc"
    ;;
esac
echo "done. Run /web-review-loop in Claude Code or Cursor Agent chat."
echo "tip: run static-check.mjs from the installed web-review-loop skill directory"

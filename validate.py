#!/usr/bin/env python3
"""Validate the web-review-loop package: required files, SKILL.md
frontmatter (<500 lines, name matches), plugin/marketplace JSON,
internal references resolve, shell syntax, node syntax of the
static checker. Exit 0 = all pass."""
import json, re, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
errors, notes = [], []

required = [
    "README.md", "install.sh", "install.ps1",
    ".claude-plugin/plugin.json", ".claude-plugin/marketplace.json",
    "skills/web-review-loop/SKILL.md",
    "skills/web-review-loop/references/web-lenses.md",
    "skills/web-review-loop/references/code-and-architecture.md",
    "skills/web-review-loop/references/web-gates.md",
    "skills/web-review-loop/references/evidence-and-severity.md",
    "skills/web-review-loop/references/plain-language-glossary.md",
    "skills/web-review-loop/templates/site-spec.md",
    "skills/web-review-loop/templates/web-review-report.md",
    "skills/web-review-loop/templates/fix-loop-log.md",
    "skills/web-review-loop/templates/project-guardrails-web.md",
    "skills/web-review-loop/scripts/static-check.mjs",
    "skills/web-review-loop/scripts/web-gate.sh",
    "cursor/web-review-guardrails.mdc",
    "examples/example-report.md",
]
for rel in required:
    if not (ROOT / rel).is_file():
        errors.append(f"missing file: {rel}")

skill = ROOT / "skills/web-review-loop/SKILL.md"
if skill.is_file():
    text = skill.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        errors.append("SKILL.md: frontmatter block not found")
    else:
        fm = m.group(1)
        name = re.search(r"^name:\s*(\S+)\s*$", fm, re.M)
        desc = re.search(r"^description:\s*(.+)$", fm, re.M)
        if not name or name.group(1) != "web-review-loop":
            errors.append("SKILL.md: name must be 'web-review-loop'")
        if not desc or len(desc.group(1)) < 40:
            errors.append("SKILL.md: description missing or too short")
    lines = text.count("\n") + 1
    notes.append(f"SKILL.md lines: {lines} (limit 500)")
    if lines >= 500:
        errors.append("SKILL.md: must stay under 500 lines")
    for ref in sorted(set(re.findall(r"`((?:references|templates|scripts)/[\w.\-]+)`", text))):
        if not (skill.parent / ref).is_file():
            errors.append(f"SKILL.md references missing file: {ref}")

for jf, want in [(".claude-plugin/plugin.json", "web-review-loop"),
                 (".claude-plugin/marketplace.json", None)]:
    p = ROOT / jf
    if p.is_file():
        try:
            data = json.loads(p.read_text(encoding="utf-8"))
            if want and data.get("name") != want:
                errors.append(f"{jf}: name must be '{want}'")
            if not want and "web-review-loop" not in [pl.get("name") for pl in data.get("plugins", [])]:
                errors.append("marketplace.json: plugins[] must include web-review-loop")
        except json.JSONDecodeError as e:
            errors.append(f"{jf}: invalid JSON: {e}")

mdc = ROOT / "cursor/web-review-guardrails.mdc"
if mdc.is_file() and "alwaysApply: true" not in mdc.read_text(encoding="utf-8"):
    errors.append("cursor rule: expected 'alwaysApply: true'")

for sh in ["skills/web-review-loop/scripts/web-gate.sh", "install.sh"]:
    p = ROOT / sh
    if p.is_file():
        r = subprocess.run(["bash", "-n", str(p)], capture_output=True, text=True)
        if r.returncode != 0:
            errors.append(f"{sh}: bash syntax error: {r.stderr.strip()}")

sc = ROOT / "skills/web-review-loop/scripts/static-check.mjs"
if sc.is_file():
    r = subprocess.run(["node", "--check", str(sc)], capture_output=True, text=True)
    if r.returncode != 0:
        errors.append(f"static-check.mjs: node syntax error: {r.stderr.strip()}")

for n in notes:
    print(f"note: {n}")
if errors:
    print("VALIDATION FAILED")
    for e in errors:
        print(f" - {e}")
    sys.exit(1)
print("VALIDATION PASSED: files, frontmatter, JSON, references, shell and node syntax OK")

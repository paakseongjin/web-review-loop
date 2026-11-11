# Web Mechanical Gates

Rule: do not install or fetch packages implicitly; use installed project tools first. `npx` may download missing packages, so check availability before using it. Use the project's own scripts/configs first (package.json
scripts, CI). This table is the discovery fallback. Record every
tool, command/URL, and result. Not installed = SKIPPED, not PASS.

## Always available in this package

| Check | Command |
|---|---|
| Static check (no deps, Node) | `node scripts/static-check.mjs <project-dir> [--budget-kb 200]` |

Heuristic regex scan of source HTML only. Results are candidate warnings, not validated defects; templates, comments, generated DOM and routing can cause false positives or omissions. Exit 0 means the scan ran, not that the site passed; exit 2 means invalid input or no HTML and must be reported SKIPPED. Never treat it as a full HTML, accessibility, security, or link check.

## Project gates (via scripts/web-gate.sh)

| Check | Command (first that exists) |
|---|---|
| Build | `npm run build` / `pnpm build` / `yarn build` / `bun run build` |
| Types | `npx tsc --noEmit` (if typescript present) |
| JS lint | `npm run lint` or `npx eslint .` |
| CSS lint | `npx stylelint "**/*.css"` (if stylelint configured) |
| Tests | `npm test` (unit/component/e2e suites the project has) |
| Secrets | `gitleaks detect --no-banner` (if installed) |

## Rendered-site checks (need a running preview or live URL)

| Check | Tool | Notes |
|---|---|---|
| Accessibility scan | `npx pa11y <url>` or axe via Playwright | Record actual tool version, configured rules and coverage; defaults do not guarantee WCAG 2.2 AA coverage. Manual checks remain necessary |
| Performance/SEO | `npx lighthouse <url> --preset=perf` or full run | `--preset=perf` runs performance only; use a full run for all four scores. Record available lab LCP/CLS/TBT; field INP requires RUM or CrUX when available. |
| HTML validation | `npx html-validate <files>` or Nu validator | Errors are findings; triage warnings |
| Screenshots/console | Browser or Playwright script | 1440 / 768 / 390 widths; save screenshots as evidence files |

## Recording format

One row per check: Tool | Command/URL | Profile/conditions |
Result (PASS/FAIL/SKIPPED) | Key output (score, error count, first
error line). Quote the first real error, not just a count — counts
without content invite blind trust, which is what this skill exists
to remove.

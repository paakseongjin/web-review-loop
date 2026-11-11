# Web Mechanical Gates

Rule: do not install or fetch packages implicitly; use installed project tools first. `npx` may download missing packages, so check availability before using it. Use the project's own scripts/configs first (package.json
scripts, CI). This table is the discovery fallback. Record every
tool, command/URL, and result. Not installed = SKIPPED, not PASS.

## Always available in this package

| Check | Command |
|---|---|
| Static check (no deps, Node) | `node scripts/static-check.mjs <project-dir> [--budget-kb 200]` |

Heuristic regex scan of source HTML only. Results are candidate warnings, not validated defects; templates, comments, generated DOM and routing can cause false positives or omissions. Exit 0 means the scan ran, not that the site passed; exit 2 means invalid input or no HTML and must be reported SKIPPED. Never treat it as a full HTML, accessibility, security, or link check.

## Preview and environment selection

1. Read the project's README, package scripts and configuration first. Prefer an already-running preview or the project's documented local development/preview command; inspect scripts for destructive operations or external side effects before starting them. Use a local-only interface and a free port where supported; never expose a private site to the public internet. Do not install dependencies implicitly.
2. For a self-contained static site only, if Python is already present and the project requires no build or server behavior, a fallback from its actual web root is `python -m http.server 8000 --bind 127.0.0.1`. Choose an unused port if needed. This cannot simulate application routes, APIs, auth or production deployment. Stop only the server process you started.
3. Use an available browser or the project's installed browser automation (e.g. Playwright) to open the selected routes, set viewport dimensions, capture screenshots and inspect console/network output. Use existing test setup where possible. No browser or missing executable means SKIPPED, not a successful visual review; continue safe source review and explain the limitation. If running locally is impossible, provide the operator with the exact remaining action and expected evidence, without asserting they must install a tool.
4. For each selected page and key flow, record URL, viewport, browser/device emulation, steps and observations. Test main actions only where safe. Redact personal information, secrets and sensitive URLs from logs and screenshots before sharing. A screenshot alone cannot prove a button works; safely exercise the action or mark it unverified. Viewport width is not a real-device certification.

## Default verification criteria

- Selected pages load at 390, 768 and 1440 CSS px unless scope or target devices call for alternatives; essential content is legible and there is no unintended page-level horizontal overflow at those tested widths.
- Each selected primary action is visibly present and, where safe, works as specified. For external submissions or purchases without an authorized test environment, check only safe steps and mark actual submission/receipt UNVERIFIED.
- No unexplained relevant uncaught console errors or failed required requests occur during the tested flows. Identify third-party, pre-existing or irrelevant errors separately; zero observed is limited to the observation window.
- Relevant project build/type/lint/tests run and pass when available and safe; skipped checks remain SKIPPED. Re-run affected checks after changes. Neither these checks nor a clean heuristic scan establishes whole-site correctness, accessibility or security.

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

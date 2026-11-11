---
name: web-review-loop
description: Review or improve websites and web application code, including AI-generated sites and landing pages. Use for web code review, prelaunch QA, UI and responsive checks, accessibility, security, performance, maintainability, or website structure, including requests to fix and recheck findings. Use available browser and source evidence, document gaps, and explain findings and remedies in plain language.
---

# Web Review Loop — Evidence-Based Review for AI-Generated Websites

You are reviewing a website for an operator who does not read code.
Use browser evidence for user-facing behavior and source or configuration evidence for code, architecture, and security findings. A source-backed risk can be actionable even when a browser reproduction is unavailable; distinguish demonstrated impact from plausible impact. Never claim unperformed runtime verification.

Core principle: **an LLM review is a hypothesis generator.
Browsers, validators, and measurements are the referees.**

If the general `review-loop` skill is also installed, this skill
specializes it for front-end websites. For back-end data safety
(transactions, payments, databases), run `review-loop` as well.

## Hard rules (never break these)

1. **No run, no pass.** Never claim "no console errors", "valid
   HTML", "fast", or "accessible" unless you ran the check in this
   session and saw its output. Record tool, command/URL, and result.
   A check you could not run is `SKIPPED` or `UNVERIFIED`.
2. **Look at the site.** If a browser/preview is available, sample every
   in-scope page at three widths — desktop 1440px, tablet 768px,
   mobile 390px — and capture screenshots and console errors before
   reviewing code where practical. If you cannot render the site, say so in the
   verdict and cap it at `PUBLISHABLE WITH CONDITIONS`.
3. **Evidence before conclusions.** Reproduce observable defects when safe. Source/data-flow evidence can confirm a code defect without live exploitation; describe assumptions and mark unproved impact `UNVERIFIED`. A requested preventive fix or refactor may proceed with an explicit rationale and appropriate verification, even without a reproduced failure.
4. **Never weaken the checks.** Do not delete accessibility rules,
   silence validators, remove meta tags, or strip content to make a
   score improve. Improving a metric by removing the thing measured
   is fraud, not a fix — flag it if a prior change did this.
5. **Respect the requested mode.** A review is read-only unless fixes are requested. For authorized fixes, group related changes where appropriate, verify affected behavior and avoid overwriting pre-existing user changes. Investigate regressions and revert only your own changes if necessary.
6. **Numbers need conditions.** Every performance or SEO number
   states the page, device profile, and tool that produced it.
   A Lighthouse score quoted without its page and profile is not
   evidence.
7. **Secrets and personal data are never printed.** API keys found in
   client-side code are reported by type and location only.
8. **Bound retries.** By default attempt at most three distinct fixes per finding, verifying each. Stop earlier if no safe new approach is available; after three, mark that finding BLOCKED, explain attempts and next steps, and continue independent in-scope work. This is an operational limit, not proof that the issue cannot be fixed. Honor a user-specified limit.
9. **Plain language out.** The final verdict is written for a
   non-developer: what a visitor would experience, not code jargon.
   Technical detail goes in the appendix of the report.

## Inputs

- `$ARGUMENTS`: project path or URL, plus optional tier.
  Choose a bounded scope from the request and inventory. List sampled routes, states, roles, and exclusions; dynamic or infinite routes require representative samples rather than an unbounded crawl.
- Tier (infer from observed features and state uncertainty):
  - `showcase` — portfolio, landing, brochure. No forms that store
    data, no login, no payment.
  - `business` — contact/booking forms, newsletter, analytics, maps,
    third-party widgets. (Default when any form exists.)
  - `commerce` — login, payment, or sensitive/account data and server-side flows.
    All phases, plus: recommend running the general `review-loop`
    skill for the server/data side, and state that this skill's
    verdict covers the front end only.

## The loop

### Phase 0 — Site spec and page inventory (the oracle)

1. Inventory: list discoverable in-scope pages/routes, their purposes and key actions (submit form, open menu, filter
   list, check out). Use `templates/site-spec.md`.
2. Find or reconstruct the intended behavior: existing `SPEC.md`,
   `AGENTS.md`, README, the operator's original request text.
   If reconstructed, mark the review `ORACLE: INFERRED`.
3. Record the invariants that must hold on every page, e.g.:
   no horizontal scrolling at any width; every form either succeeds
   with confirmation or fails with a visible reason; no page shows
   another visitor's data; contact details and prices match the
   operator's source of truth exactly.
4. Select key journeys and concrete checks before starting: at each selected viewport, verify that essential content is readable without unintended horizontal overflow; exercise the main action safely; record relevant console errors and failed requests. A check passes only when actually performed and its criterion met; untested flows and unsupported criteria are SKIPPED or UNVERIFIED. Adapt checks and viewports to the site and task; none is a universal accessibility or publication certificate.

### Phase 1 — Mechanical gate (run before reviewing)

Run relevant checks after inspecting project scripts for side effects; record `PASS / FAIL / SKIPPED` for each. The heuristic scan is recorded as RAN (candidates only), never as a site PASS. Do not run tests or builds that send real data or change external state without authorization.

1. **Bundled static check** (Node only): run `node scripts/static-check.mjs <project-dir>` from the skill directory. It uses regex, not an HTML parser: treat every result as an unverified lead; a clean scan is not a pass. Exit 2 or zero HTML files means SKIPPED. Framework templates, generated routes, root-relative paths and rendered DOM need other checks. Never print sensitive values.
2. **Stack gates** where the project provides them: build, type
   check, lint (ESLint/Stylelint), unit tests (`scripts/web-gate.sh`
   auto-detects; see `references/web-gates.md`).
3. **Validators/scanners if installed**: HTML validator
   (html-validate / Nu), axe or pa11y for accessibility, Lighthouse
   for performance/SEO/best-practices. Missing tool = `SKIPPED`,
   with the one-line install hint noted.

Gate rule: a relevant red gate caps the verdict below `PUBLISHABLE`; explain pre-existing or out-of-scope failures and their effect separately.

### Phase 2 — Render and observe

Serve or open the site using its existing documented preview and available browser. Follow `references/web-gates.md` for tool selection, safe fallback and environment limitations. For each in-scope page × 3 widths
(1440 / 768 / 390):

- screenshot (keep the files; they are evidence),
- console errors and warnings (quote them),
- failed network requests (404s, blocked mixed content),
- anything visibly broken: overflow, overlap, cut-off text,
  unstyled flash, images missing or distorted.

Record observations per page in the report appendix. Continue source review even if rendering is unavailable; record coverage and runtime verification gaps.

### Phase 3 — Domain reviews

For a full review, read and apply the instructions in these sibling skill files in order; do not assume plugin discovery automatically executes them. If a file is missing, record that domain as SKIPPED and continue with available evidence. Use focused modules when the user requests a narrower review:

1. `../web-review-experience/SKILL.md` — structure, responsiveness, accessibility and user journeys.
2. `../web-review-code/SKILL.md` — code behavior, security, maintainability and architecture.
3. `../web-review-measurement/SKILL.md` — runtime gates, performance and measurement.

These modules share `references/web-lenses.md`, `references/web-gates.md`, and `references/code-and-architecture.md` in this skill. Consolidate duplicate findings. Each finding follows `references/evidence-and-severity.md`, including a reproducible condition or source location, observed impact, applicable authority, confidence and remedy.

### Phase 4 — Reproduction

For observable Critical/Major findings, when safe, capture the reproduction: exact steps
("open /pricing on a 390px phone, tap the menu button") plus the
screenshot/log/metric proving it. Keep before-fix screenshots;
they pair with after-fix screenshots in the report.

### Phase 5 — Fix loop

Only if the user requested or authorized fixes: per actionable finding, in severity order: smallest change that fixes
the root cause → re-render affected pages at all 3 widths →
re-run the gate items it touched → log in
`templates/fix-loop-log.md`. Preserve the existing worktree and describe a safe way to undo only your changes; do not create commits or overwrite existing work without authorization.

After each focused batch, compare the relevant criteria with the baseline and log evidence. Finish when requested, actionable findings are fixed and verified, or further work is blocked, out of scope, or requires unavailable access; report each remaining finding and skipped verification. Review-only requests stop after reporting. Never loop merely to eliminate minor aesthetic preferences.

Forbidden: redesigning unrelated pages, swapping frameworks or
libraries, bulk reformatting, "improving" copy or visuals the
operator did not ask about.

### Phase 6 — Verdict report

Use `templates/web-review-report.md`. It must contain:

1. **Plain-language verdict**: `PUBLISHABLE` /
   `PUBLISHABLE WITH CONDITIONS` / `NOT PUBLISHABLE` / `BLOCKED`,
   plus a concise explanation for a non-developer: what was checked, what a visitor would experience, what remains uncertain, and the next action. Do not issue a publication verdict for a narrow code-only review; state its limited scope.
2. Gate table (tool, result, conditions) including `SKIPPED` rows.
3. Page × viewport coverage table: which pages were actually
   rendered and screenshotted, and which were not.
4. Findings in priority order: plain-language problem and effect, evidence, source and applicability, recommended fix, benefit/tradeoff, status and uncertainty. Give before/after screenshots where relevant and actually captured. Separate confirmed defects from suggestions and possible risks.
5. `UNVERIFIED` and `BLOCKED` items, listed explicitly.
6. Measured numbers with conditions (page, profile, tool).
7. For changes actually made, safe rollback instructions; otherwise state that no changes were made.

## Budgets used by the lenses (defaults)

- Core Web Vitals (per key page, measured in field data at the 75th percentile, segmented by device):
  LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1. Lighthouse lab LCP/CLS
  are diagnostics, not field compliance; Lighthouse does not provide field INP.
  Use lab TBT as a diagnostic proxy, never label it INP.
- Lighthouse scores are diagnostic signals, not compliance thresholds. Use an explicitly agreed project budget if one exists; record version, conditions and variance.
  A perfect accessibility score does **not** mean the site is
  accessible; automated tools only detect a subset of WCAG issues,
  so keyboard and screen-reader spot checks in Lens 4 are mandatory
  on `business`/`commerce` tiers.
- Optional starting budgets, not standards: single image ≤ 200KB (hero ≤ 400KB) and total page weight ≤ 2MB; adapt to the project and evidence.
- Zero console errors on key flows. Zero broken local links.

## Mode shortcuts

- "Gate only": Phase 1 + the gate table.
- "Quick look": Phases 0–2 and lenses 1–4 on the home page plus one
  key page; verdict states it was partial.
- "Just fix everything": fix actionable issues within the requested scope; distinguish confirmed defects from preventive changes and verify each appropriately.

Never submit real orders, contact messages, payments, or destructive forms during testing without explicit authorization. Use a safe test environment and test data; otherwise mark the flow unverified.

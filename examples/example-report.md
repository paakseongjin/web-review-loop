# Web Review Report — 맑은치과 소개 사이트 — 2026-11-11 (EXAMPLE — fictional)

## Verdict: PUBLISHABLE WITH CONDITIONS

Plain-language summary:
- What was checked: 5 pages, all opened in a browser at phone,
  tablet, and desktop widths. The built-in static check, an
  accessibility scan, and a speed measurement were actually run.
  The reservation form was submitted once with good data and once
  with bad data.
- What a visitor would run into today: on a phone, the price table
  on the treatment page sticks out past the screen edge, so the
  prices on the right cannot be read. Everything else a visitor
  touches — menu, phone-call button, reservation form — works.
- What remains risky: the accessibility score from the machine scan
  is 100, but the keyboard check found the popup close button cannot
  be reached by keyboard. That is scheduled as a condition below,
  not hidden.

Tier: business · Oracle: REAL (operator's price list file) ·
Rendered: YES

## Mechanical gate

| Tool | Conditions | Result | Key output |
|---|---|---|---|
| static-check | `node static-check.mjs .` | RAN | WARN=2 (unverified candidates) (two images over budget) |
| build | `npm run build` | PASS | exit 0 |
| lint | `npm run lint` | PASS | exit 0 |
| HTML validator | html-validate | SKIPPED | not installed |
| axe/pa11y | pa11y, WCAG 2.2 AA | PASS | 0 errors on 5 pages |
| Lighthouse | mobile, / | SCORES | Perf 88 · A11y 100 · BP 96 · SEO 100; LCP 2.1s · CLS 0.04 · INP n/a (lab) |

## Coverage

| Page | 1440 | 768 | 390 | Console errors |
|---|---|---|---|---|
| / | ✓ | ✓ | ✓ | 0 |
| /treatment | ✓ | ✓ | ✓ | 0 |
| /price | ✓ | ✓ | ✓ | 0 |
| /reserve | ✓ | ✓ | ✓ | 0 |
| /directions | ✓ | ✓ | ✓ | 1 (map widget warning) |

## Findings

Counts: Critical 0 · Major 1 · Minor 2 · UNVERIFIED 1

| ID | Lens | Severity | Status | Page/viewport | Summary |
|---|---|---|---|---|---|
| W-01 | 2 Responsive | Major | CONFIRMED | /price, 390px | Price table overflows the phone screen; right column unreadable (screenshot price-390-before.png) |
| W-02 | 4 Accessibility | Major | CONFIRMED | all, keyboard | Popup close button unreachable by keyboard despite a perfect automated score |
| W-03 | 5 Performance | Minor | CONFIRMED | /, mobile | Two images 260–310KB; resizing brings LCP down further |
| W-04 | 7 Privacy | — | UNVERIFIED | /reserve | Whether the form service stores submissions in the operator's account could not be verified from the site alone — operator to confirm in the service dashboard |

Conditions for publish: fix W-01 and W-02 and verify both affected flows. W-02 currently blocks keyboard-only visitors.

## Rollback

Pre-fix backup: commit `a1b2c3d`. Undo: redeploy that commit.

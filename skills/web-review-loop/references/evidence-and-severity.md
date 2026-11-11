# Evidence Format and Severity (Web)

## Finding format (required)

```
ID: W-02
Lens: 4 (Accessibility)
Severity: Major
Status: CONFIRMED | UNVERIFIED | BLOCKED | FIXED
Page/Viewport: /contact, mobile 390px
Visitor experience: The submit button cannot be reached by keyboard;
  a keyboard-only visitor cannot send the form at all.
Expected: Every interactive element is reachable and operable by
  keyboard, with visible focus.
Actual: Focus jumps from the email field straight to the footer;
  the button is skipped (it is a clickable <div>).
Evidence: screenshot shots/contact-390-before.png; keyboard walk
  recorded in Phase 2 notes; source src contact form markup line 57.
Fix: changed the div to a real <button type="submit">; keyboard walk
  re-run passes; screenshot shots/contact-390-after.png.
```

Use page/viewport for rendered findings; source findings need a file, line and evidence of the affected data flow or dependency. Distinguish confirmed conditions from unverified impact.

## Evidence and claim audit

Before reporting, trace each material claim to project evidence and its criterion separately. Record the exact file and line or a reproducible observation, the relevant expected behavior and its origin (project requirement, applicable standard provision, official versioned documentation or clearly labeled recommendation). Confirm the observed condition satisfies the criterion's scope and exceptions. A source can establish a rule, but cannot prove the project violates it; a test can show observed behavior but cannot establish universal compliance. If the behavior, criterion or applicability is uncertain, say which part is unknown. Distinguish a demonstrable code defect from an unverified runtime impact; do not present scanner warnings alone as confirmed defects. Do not fabricate sources, citations, test results or certainty.

Classify as **must fix** when an evidenced defect blocks a requested or explicitly agreed critical behavior, or creates a material risk that must be addressed before the relevant decision. Explain the concrete consequence and timing, and cite the applicable criterion where one exists. An unverified high-impact risk can require urgent investigation or mitigation; label the risk unverified rather than calling it a confirmed defect. Do not present severity, style preferences, generic advice, or a benchmark alone as proof of a legal requirement or universal release blocker. If no must-fix issue is evidenced, say none was found within the inspected scope, not that none exists.

For **strengths**, cite an actually inspected implementation or executed check, its scope, the intended criterion and why it helps. For **preserve**, name the specific useful behavior or invariant, evidence and the affected change, and suggest a focused regression check. A source inspection may demonstrate a code pattern without proving the running feature works. If there is insufficient evidence for a strength or preservation claim, say it was not verified; do not manufacture a positive finding. Never imply that one passing check proves a complete security, accessibility or compliance assessment.

## Numerical claims

Use a number only if directly measured, counted in the stated sample, calculated from recorded inputs, or verified in a source. Identify which it is. Include units, date or test conditions, tool/version, environment, and route or component where relevant; for sample statistics give sample size and denominator, for a calculated change show both inputs and formula, and for repeated measurements state the aggregation. Quote an external threshold with its precise source, version or date, applicability, and conditions; distinguish it from a project target or optional heuristic. Do not claim an improvement or percentage from a single baseline, an unmeasured estimate, or an unrelated benchmark. If the data or source is unavailable, omit the number and label the claim unverified rather than estimating it. Counts describe only the inspected scope and are not coverage or defect-rate estimates without a defined denominator.

## Severity

Explain priority with the affected flow, user group, evidence, likelihood and scope. A score or project-budget miss alone is not automatically Major or a standard violation. When impact or measurement is unknown, label it unverified and request the missing evidence.

- **Critical** — for example, a genuinely essential flow is unusable, an active secret is exposed, or personal data is demonstrably leaked. Assess actual context and impact; an apparent key or possible leak needs verification. Under this review process, a confirmed Critical blocks a publication recommendation.
- **Major** — a real visitor group is blocked or misled (keyboard
  users, mobile users); wrong price/contact/fact on a live page;
  measured accessibility failure or performance problem with demonstrated material user impact;
  form errors silently lose user input. Blocks publish on
  `business`/`commerce`.
- **Minor** — quality and drift issues with a workaround: dead CSS,
  a missing OG image on a minor page, a slightly heavy image,
  placeholder-free but sloppy copy. Listed, not blocking.
- **Note** — observation without a failing scenario.

## Verdict mapping

These are this skill’s conservative review defaults, not legal rules or external certification criteria. Apply them only to a requested publication decision and the examined scope; explain the evidence and concrete impact behind the severity.

- Any confirmed Critical not FIXED → `NOT PUBLISHABLE`.
- Any confirmed Major not FIXED on `business`/`commerce` → `NOT PUBLISHABLE`;
  on `showcase` → at best `PUBLISHABLE WITH CONDITIONS`.
- Site never rendered in this session → at best
  `PUBLISHABLE WITH CONDITIONS`, with the gap stated first.
- Gate red on in-scope pages → never `PUBLISHABLE`.
- Oracle INFERRED → at best `PUBLISHABLE WITH CONDITIONS`.
- SKIPPED checks and UNVERIFIED findings are always printed in the
  verdict. A clean verdict with hidden caveats is a failure of this
  skill, not a success.

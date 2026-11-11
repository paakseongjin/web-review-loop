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

## Severity

Explain priority with the affected flow, user group, evidence, likelihood and scope. A score or project-budget miss alone is not automatically Major or a standard violation. When impact or measurement is unknown, label it unverified and request the missing evidence.

- **Critical** — a key flow is unusable (form cannot be submitted,
  checkout/menu broken); a secret key is exposed in client code;
  visitors' personal data leaks (e.g. in URLs or to an unintended
  third party); the page is unusable at a common viewport.
  Blocks publish.
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

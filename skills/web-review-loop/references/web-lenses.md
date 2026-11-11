# Web Review Lenses

Run each lens separately. A finding needs: page + viewport, what a
visitor experiences, expected vs. actual, and evidence (screenshot,
console line, measurement, or file:line). Otherwise UNVERIFIED.

## Lens 1 — HTML Structure & Semantics

- Use a clear main heading and meaningful heading hierarchy. A single `<h1>` is a useful convention, not a universal WCAG requirement; assess skipped levels in context.
- Semantic landmarks present (`header`, `nav`, `main`, `footer`);
  buttons are `<button>`, links are `<a href>` — not clickable divs.
- `<html lang>` matches the page language; `<title>` unique per page
  and describes the page; meta description present.
- Images have meaningful `alt` (or `alt=""` when purely decorative);
  form inputs have real `<label>`s, not placeholder-only labels.
- Validator errors (html-validate / Nu) are findings; warnings are
  triaged, not silently ignored.
- Duplicate `id`s are a defect (breaks labels, anchors, JS lookups).

## Lens 2 — CSS & Responsive Layout

- No horizontal scrolling at 360 / 390 / 768 / 1440px widths.
- No overlap, cut-off, or unreadably small text at any width; tap
  prefer generous targets (44×44 CSS px where practical); evaluate WCAG 2.2 AA against 24×24 CSS px and its exceptions.
- Layout does not jump while loading (space reserved for images,
  ads, embeds, webfonts) — ties to CLS in Lens 5.
- The design follows the project's existing tokens/conventions;
  one-off hard-coded colors/spacings that duplicate a token are
  Minor; a second, conflicting style system is Major.
- States exist and look intentional: hover, focus-visible (keyboard
  users must see focus), active, disabled, loading.
- Dark mode, if present, is complete: no unreadable surface pairs.
- No `!important` wars or specificity traps that make the next edit
  unpredictable; dead CSS for removed features is Minor drift.

## Lens 3 — JavaScript Behavior & Safety

- Zero uncaught errors in the console on every key flow.
- No user input is inserted into the page unsanitized
  (trace untrusted data to dangerous sinks such as `innerHTML`; assess escaping, sanitization and reachability before assigning severity).
  Prefer `textContent` / framework escaping.
- Inline event handlers (`onclick=` etc.) and `javascript:` URLs are
  findings on `business`/`commerce` tiers (they fight CSP and hide
  behavior).
- Event listeners actually attached after dynamic content loads;
  buttons that silently do nothing are Critical on key flows.
- Async work shows loading and error states; a failed request never
  looks like success, and never leaves a spinner forever.
- No leftover `console.log` debugging, commented-out feature blocks,
  or dead code shipped as finished work.
- Third-party scripts load async/defer where possible and come only
  from sources the operator intended (list them in the report).

## Lens 4 — Accessibility (WCAG 2.2 AA target)

Automated scan (axe / pa11y / Lighthouse) first — then remember it
detects only a subset of issues. Manual spot checks are mandatory
on `business`/`commerce` tiers:

- Keyboard only: can you reach and operate the menu, forms, dialogs,
  and the main call-to-action? Is focus always visible? Does Esc
  close dialogs? No keyboard traps.
- Contrast: text ≥ 4.5:1 (large text ≥ 3:1), including over images
  and in relevant hover states. Inactive controls are exempt from the WCAG text contrast criterion; assess usability separately. Measure rather than eyeball.
- Screen reader basics: images' alt makes sense read aloud; form
  errors are announced and tied to their fields; page title and
  headings describe the page when read as a list.
- Motion: `prefers-reduced-motion` respected for non-essential
  animation; nothing flashes more than 3 times per second.
- Zoom to 200%: content still usable, nothing clipped away.
- Targets: WCAG 2.2 AA 2.5.8 uses 24×24 CSS px with spacing and other exceptions; 44×44 is the enhanced AAA target and a useful design goal. Inputs need appropriate labels and autocomplete.
- A Lighthouse/axe score of 100 does **not** close this lens.
  Report what was checked manually and what was not.

## Lens 5 — Performance (Core Web Vitals)

Field targets at the 75th percentile, by device: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1. Lab LCP/CLS and TBT diagnose problems but do not establish field compliance or measure field INP. Page weight ≤ 2MB and image sizes ≤ 200KB (hero ≤ 400KB) are optional project budgets, not web standards; adapt to content, quality and actual measurements.

- What is the largest element, and is it prioritized (not lazy-loaded
  if it is the hero; lazy-load what is below the fold)?
- Render-blocking CSS/JS in the head that is not needed for first
  paint; unused JS shipped to every page (framework/widget bloat).
- Fonts: displayed without invisible-text flash; subset/preload
  where the project already does so.
- Every number in the report names page + profile + tool. Lab
  numbers are a proxy; after launch, field data (Search Console /
  CrUX) is the deciding source — say so in the verdict.

## Lens 6 — SEO & Sharing

- Unique title + meta description per page, matching page content.
- Open Graph / Twitter cards present; share preview image exists
  and renders (check the actual image file, not just the tag).
- Canonical URL set where duplicates can occur; `sitemap.xml` and
  `robots.txt` exist and agree with the pages actually published;
  no accidental `noindex` on pages meant to be found.
- Semantic headings (Lens 1) double as the search outline; images
  have descriptive file names/alt where it matters.
- Structured data (JSON-LD), if present, validates and matches
  visible content (no fake ratings/reviews — a trust and policy risk).
- Language/region tags (`lang`, hreflang) match the real audience.
- Honesty rule: report what was verified. Never promise rankings.

## Lens 7 — Security & Privacy (client side)

- The site is served over HTTPS; no mixed content (http:// resources
  on https pages); HSTS where the host supports it.
- **No secret keys in client code.** Publishable/public keys are
  fine; secret keys, service-role keys, private tokens in JS, HTML,
  or meta tags are Critical. Report type + location only.
- Forms do not expose personal data in URLs (GET with emails/names);
  submitted data goes where the operator thinks it goes — name the
  actual endpoint/service in the report.
- Privacy: analytics/ trackers match the operator's consent setup;
  a cookie banner that does not actually block trackers is a Major
  finding on `business`/`commerce`.
- Check `target="_blank"` behavior against the supported browsers: current browsers generally imply `noopener`; assess explicit `rel` for legacy support or project policy rather than declaring its absence an automatic vulnerability.
- Third-party embeds (maps, chat, video) are inventoried; anything
  the operator did not intend is a finding.
- Where the host supports them, note missing security headers
  (CSP, X-Content-Type-Options, Referrer-Policy) as Minor/Note for
  `showcase`, Major for `commerce`.

## Lens 8 — Forms & User Flows

Walk every key flow as a visitor, including the unhappy paths:

- In an authorized test environment, submit safe test data and verify confirmation and receipt. Never send real messages, create orders, or perform payments without explicit authorization; otherwise mark receipt unverified.
- Submit with invalid/empty data → specific, visible errors next to
  the fields; nothing is silently lost; entered data is preserved.
- Double-submit (double click / slow network) → no duplicate
  messages/orders (ties to idempotency on the server side).
- Loading, success, error, and empty states all exist and are
  understandable without instructions.
- Required fields are marked before submission, not only after an
  error. Error text is plain language.
- Back button, refresh mid-flow, and closing the tab do not corrupt
  the flow or lose data the user was promised was saved.
- Contact channels on the page (tel:, mailto:, map links) actually
  dial/open the right target.

## Lens 9 — Content Integrity

The operator cannot spot wrong facts by reading code — check them
against the source of truth the operator provides:

- Prices, dates, hours, phone numbers, addresses, names match the
  operator's source exactly, on every page they appear (including
  footer, JSON-LD, and OG text — drift hides there).
- No placeholder text shipped ("Lorem ipsum", "TODO", "coming
  soon" on live pages), no sample/test data presented as real.
- No claims the operator cannot substantiate (awards, rankings,
  "No.1", medical/financial effect claims). Flag, do not rewrite.
- Spelling/grammar pass on visible copy; broken sentences from
  generation truncation are findings.
- Verify time-sensitive dates and promotions; an older copyright year alone is not evidence of a defect.

## Lens 10 — Assets, Links & Third Parties

- Every local link/image/script/style resolves to a real file
  (the static scan only suggests candidates; route-aware verification is required).
- External links work and go where their text promises; no links
  to staging/localhost addresses in production pages.
- Images are the right images (not swapped, not stock photos
  presented as the operator's own work), correctly oriented,
  and not distorted by forced dimensions.
- Favicon and app icons exist; 404 page exists, is styled, and
  offers a way back.
- Licenses: fonts/images/libraries with attribution requirements
  are credited where required; anything of unknown origin the
  operator does not have rights to is flagged as a risk note.

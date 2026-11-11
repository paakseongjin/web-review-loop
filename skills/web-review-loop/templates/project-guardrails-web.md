# Website Guardrails (paste into AGENTS.md / CLAUDE.md)

Standing rules for every change to this website.

## Verification

- Before claiming work is done, open the changed pages in a browser
  (or preview) at phone (390px) and desktop (1440px) widths and
  report console errors honestly. A page you did not render is
  reported as not rendered.
- Never remove alt text, labels, meta tags, or validation rules to
  make a check or score pass.
- Every fix states how it was verified: screenshot, console, or
  measured number — not "should work now".

## Structure and accessibility

- Semantic HTML: real buttons and links, a clear main heading, headings
  in order, every input labelled, every image has alt text.
- Every interactive element works by keyboard with visible focus.
- No layout may scroll sideways at 360–1440px widths.

## Safety

- Never put secret API keys in client-side code, HTML, or meta tags.
  Public/publishable keys only, and name them as such.
- Handle untrusted data with context-appropriate escaping or
  sanitization; use textContent when inserting plain text.
- Forms validate before sending, show plain-language errors, and
  never report success when the send failed.

## Content and assets

- Prices, hours, contacts, and names are copied from the operator's
  source of truth, character for character. No invented claims,
  ratings, or awards.
- No placeholder text, sample data, or test content on live pages.
- Images: appropriate content and dimensions; optimize against the
  project budget without degrading necessary quality.

## Change discipline

- Small changes, one concern at a time. No redesigns, framework
  swaps, or bulk reformatting inside a fix.
- New third-party scripts or embeds require naming them in the
  change description (what company, what data they can see).

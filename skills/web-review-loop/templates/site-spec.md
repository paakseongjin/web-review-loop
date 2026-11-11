# Site Spec — <site name>

Write in plain language. This is the review's yardstick.
If it was reconstructed by the reviewer instead of provided by the
operator, mark it: ORACLE: INFERRED.

## Pages

| Page (URL/path) | Purpose in one sentence | Key actions a visitor takes |
|---|---|---|
| / | | |
| /about | | |
| /contact | | |

## Must always be true (invariants)

- No page scrolls sideways at phone, tablet, or desktop widths.
- Every form ends in either a visible confirmation or a visible
  reason it failed — never silence.
- The phone number / address / prices shown are: <source of truth>
- <add project-specific invariants>

## Forms and where submissions go

| Form | Sends to (service/endpoint) | Confirmation the visitor sees |
|---|---|---|
| Contact | | |

## Third parties the operator intends to use

- Analytics: <none / name>
- Chat/widget: <none / name>
- Maps/video embeds: <none / name>
- Fonts: <names>

## Out of scope / must not happen

- No test or sample content on live pages.
- No pages the operator did not ask for being publicly linked.

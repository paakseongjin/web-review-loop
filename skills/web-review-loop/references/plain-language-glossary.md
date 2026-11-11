# Plain-Language Glossary (for the operator)

Use these explanations in the verdict whenever a term appears.
The operator does not read code; if they cannot understand the
verdict, the review failed at its last step.

- **Console errors** — error messages the browser records behind the
  scenes. Visitors don't see them, but they usually mean a button,
  form, or feature silently failed.
- **Responsive** — the page rearranges itself to fit phone, tablet,
  and desktop screens. Broken responsive design = sideways scrolling,
  overlapping text, or buttons too small to tap on a phone.
- **Accessibility (a11y)** — whether people using only a keyboard,
  a screen reader, or enlarged text can use the site. Partly a legal
  requirement in many markets, and it overlaps with general usability.
- **LCP / INP / CLS (Core Web Vitals)** — Google's three visitor
  experience measurements: how fast the main content appears
  (LCP, good ≤ 2.5s), how quickly the page reacts to a tap or click
  (INP, good ≤ 200ms), and whether content jumps around while
  loading (CLS, good ≤ 0.1).
- **Lighthouse score** — a 0–100 lab grade from Google's tool for
  speed, accessibility, practices, and SEO. Useful as a trend signal.
  A high score is not a certificate: the accessibility score in
  particular only covers the issues a machine can detect.
- **SEO / meta / Open Graph** — the titles, descriptions, and preview
  images that search engines and messengers (KakaoTalk, Facebook)
  show when your page is linked. Wrong or missing ones mean your
  link looks broken or shows the wrong text everywhere it is shared.
- **Alt text** — the written description attached to an image. Screen
  readers read it aloud; search engines read it too. Missing alt =
  the image is invisible to both.
- **Secret key in client code** — a password-like key placed in the
  web page itself, where anyone can view it ("view source"). If it is
  a *secret* key (not a public/publishable one), anyone can misuse
  your account. This is one of the few findings that needs fixing
  before anything else.
- **Mixed content** — a secure (https) page loading some files over
  insecure (http) connections. Browsers block or warn, and parts of
  the page can break.
- **404 / broken link** — a link or image that points at a file that
  does not exist. Visitors see a missing image or an error page.
- **Form validation** — the checks that tell a visitor "this email
  address looks wrong" before sending. Missing validation = lost
  messages and junk data arriving in your inbox.
- **Third-party script** — code loaded from another company's site
  (analytics, chat widgets, maps). Each one can slow the page and
  see visitor data, so the report lists every one found.
- **Rollback** — the prepared way to return the site to the previous
  working version if a fix or a launch goes wrong.

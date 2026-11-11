---
name: web-review-code
description: Review website code, architecture, security and maintainability using source evidence. Use for web code or structure reviews.
---

# Web code and architecture review

Read `../web-review-loop/references/code-and-architecture.md`, `../web-review-loop/references/full-stack-workflow.md`, `../web-review-loop/references/evidence-and-severity.md`, `../web-review-loop/references/review-convergence.md`, and `../web-review-loop/references/web-lenses.md` lenses 3 and 7. Trace the affected code and callers, trust boundaries and failure paths. Tie each finding to a file and line, trigger, evidence and actual or explicitly uncertain impact; cite applicable standards or version-specific official documentation when making normative claims. Do not call a design defect based solely on size, age, style choice or a second design system. Verify candidates, distinguish pre-existing issues from regressions, and carry a deduplicated finding ledger across bounded review rounds. Identify evidence-backed must-fix issues, strengths and behaviors to preserve; do not invent positive findings or numerical claims. For a full loop, return findings and gaps to the orchestrator; for a focused request, report only its scope.

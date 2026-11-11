# Code review and web architecture

Read this lens for source-based reviews, refactoring, or structure/design questions. Identify the requested diff or scope, affected routes, entry points, dependencies, shared components, data flow, and existing conventions before judging changes. Review the diff and its callers; for a full audit sample high-risk paths and document coverage.

## Review for observable consequences

- Trace untrusted input across rendering, network and storage boundaries; check authentication, authorization and server validation where source and scope permit. Client checks alone cannot establish server safety. Do not expose secrets or exploit a live service.
- Check correctness at boundaries: empty/loading/error states, async cancellation and races, stale state, cleanup of subscriptions, API failures, navigation and persistence. Check tests for missing behavior or regressions, not merely line coverage.
- For each actionable issue state location, trigger, consequence, evidence, confidence and a proportionate remedy. Separate proven defects from maintainability risks and speculative issues. Avoid flagging formatting or preferences as defects.
- Assess dependencies, configuration, environments, build artifacts and public/private boundaries. Scope security conclusions to what was actually examined.

## Maintainable boundaries and oversized code

Find candidates using file/function/component length as a triage signal only; include concrete evidence such as unrelated responsibilities, deeply nested branches, repeated logic, tangled side effects, coupling or difficulty testing and changing a feature. Generated code, cohesive tables, and framework conventions may legitimately be large. No universal line threshold implies a defect.

Propose or, when authorized, implement small behavior-preserving extractions along stable responsibilities: route/page composition, reusable UI, domain logic, data access, state/side effects, validation and styles. Keep related code together; avoid single-use abstractions, circular imports, new layers or scattered files that increase navigation cost. Preserve public interfaces, accessibility, routing, styling, data flow and existing project conventions. Explain the boundary and expected benefit. Test affected behavior before and after where practical; run relevant build/type/lint/tests and browser checks, reporting gaps. Refactoring alone is not a reason to rewrite a framework or change behavior.

## Page and interaction design

Map users, goals, content priority, route hierarchy, navigation and key journeys. For relevant flows check semantic landmarks and headings, consistent navigation, responsive layout, accessibility, visual hierarchy, readable content, and loading/empty/error/success states. Identify where state lives, what is shared, and boundaries between server and client. Recommend proportionate changes tied to a user task or maintainability evidence; preserve the existing visual identity and requirements. Use project design tokens and existing components where appropriate. Do not prescribe a particular folder pattern or architecture regardless of scale.

## Language, framework and currency review

Inventory languages and framework versions from manifests, lockfiles, configuration and runtime where available. Identify actual supported browsers and runtime versions; if unknown, state the assumption. Examine HTML semantics, CSS layout and compatibility, JavaScript/TypeScript behavior and types, and the relevant framework's routing, rendering, state and lifecycle. For server-side languages or infrastructure encountered, assess within the user's scope and skill available; explicitly name gaps rather than claiming a complete security audit.

For a suspected obsolete or unsafe feature, verify the exact API, installed version and support status against current official documentation and migration/release notes; use browser compatibility tables or MDN Baseline as context, not a guarantee for the project's target devices. Distinguish deprecated, removed, unsupported, vulnerable, non-standard, experimental, merely old and stylistic preference. An old version or pattern is not automatically a defect. Identify impact and applicability, cite a precise authoritative URL and date checked, and propose an alternative compatible with the project. Consider migration cost, breaking changes and regression tests. If current documentation cannot be verified, say so and mark currency unverified. Do not require upgrades solely for novelty or install packages to check.

## Sources and confidence

Use project requirements, reproducible runtime observations and source as evidence of the site's behavior; standards and official versioned documentation establish what a rule says, not that this particular site fails it. Prefer applicable normative standards, domestic public guidance, official framework/vendor documentation, OWASP and peer-reviewed research. Record rule or section, version and URL near each consequential recommendation; distinguish legal obligations from guidance and avoid a legal-compliance verdict. Date-check rapidly changing claims, verify actual applicability, exceptions and target versions. If a source cannot be checked, label the limitation rather than inventing a citation. A single study or guideline is not universal proof.

## Review and fix loop

1. Baseline the requested scope and existing state; identify change mode and risk. Review the actual diff and affected dependencies when present; use a bounded representative selection for larger sites.
2. Gather evidence independently from code, safe execution, existing checks and applicable rules. Record checks not performed. Classify confirmed defects, potential risks, modernization suggestions and choices separately; prioritize by demonstrated impact and urgency.
3. Provide the user a reviewable decision: what happens, who it affects, evidence and source, recommendation, expected benefit, possible tradeoff, priority and what remains unknown. Do not make a finding sound confirmed merely because a tool warned.
4. If fixes are requested, implement focused changes, verify affected behavior and compare against baseline; rerun relevant checks and affected routes. Record what changed, passed, failed or was skipped. Repeat only on remaining actionable findings, reassessing after each meaningful batch. If a failure repeats, investigate a different cause, report the blocker and stop rather than spinning indefinitely. Review-only requests end with recommendations and make no edits.
5. Never imply all pages or all security issues are covered from a sample. A clean finding list describes only inspected scope, not proof of absence.

## Standards and research (verify applicability and current versions)

- W3C WCAG 2.2: https://www.w3.org/TR/WCAG22/ — success criteria and exceptions; automated tests cover only part of accessibility.
- Seoul accessibility and web standards guidance: https://news.seoul.go.kr/gov/archives/47485 — cites KWCAG 2.2 and Korean public-sector guidance. Check actual jurisdiction and project obligations; WCAG and KWCAG are distinct, and an informal review is not certification.
- OWASP secure code review: https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html — architecture, trust boundaries, manual and automated review.
- Core Web Vitals: https://web.dev/articles/vitals and https://web.dev/articles/optimize-inp — field percentile and lab/field distinction.
- Sadowski et al., Modern Code Review: A Case Study at Google (2018): https://research.google/pubs/modern-code-review-a-case-study-at-google/ — an industrial case study, not a universal process rule.
- Fowler, Refactoring Boundary: https://martinfowler.com/bliki/RefactoringBoundary.html — small behavior-preserving changes aimed at making code easier to modify.
- KRDS digital government UI/UX resources: https://www.krds.go.kr/html/site/outline/outline_05.html — public-service guidance; applicability depends on the organization and context.
- MDN Baseline: https://developer.mozilla.org/en-US/docs/Glossary/Baseline/Compatibility — compatibility summary, not a substitute for target-device tests.
- MDN mixed content: https://developer.mozilla.org/en-US/docs/Web/Security/Defenses/Mixed_content — distinguishes insecure subresources from ordinary top-level navigation.
- MDN noopener: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes/rel/noopener — implicit behavior in modern browsers; confirm legacy requirements.

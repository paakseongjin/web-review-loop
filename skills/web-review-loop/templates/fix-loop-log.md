# Review and Fix Loop Log — <site/scope>

Use in memory for read-only review; write a file only if requested or authorized. A round includes review, any authorized fix batch and its focused verification. Default maximum: three rounds total and three distinct fix attempts per finding; the first applicable limit stops that activity. User-specified limits take precedence. Preserve material risks and unresolved work in the final report.

- Starting revision or baseline, pre-existing work and its limitations: <...>
- Scope, acceptance criteria and checks: <...>
- Reviewed state / last changed scope: <...>

| Finding ID / failure class | Origin: introduced / pre-existing / unknown | Evidence and impact | Disposition and reason | Linked regression |
|---|---|---|---|---|
| W-01 | | | open / fixed and verified / rejected / deferred / blocked / unverified | |

| Round | Reviewed state and scope | Fix batch / attempt per finding | Focused checks and affected regression checks | New material issue or failed check | Result |
|---|---|---|---|---|---|
| 1 | | | | | |

## Stop and handoff

- Actual rounds and stop reason: <criteria met / round limit / blocked / other>
- Remaining or newly discovered material risks and next action: <...>
- Failed, skipped or unverified checks, and what is needed: <...>
- Safe rollback of this session's changes, if applicable: <...>

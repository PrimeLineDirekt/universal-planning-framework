# Verify Report Template

A verify report is the sibling file to a plan. It proves that each Phase Gate
actually passed, by pasting evidence rather than asserting an outcome.

The plan says what should happen. The verify report shows what did.

**Adapted from** the OpenSpec change-management `verify-report.md` pattern in
[Gentleman-Programming/engram](https://github.com/Gentleman-Programming/engram) (MIT).

## When to write one

Write one for a Grade B or A plan that ships something real. It is optional for a
Grade C plan, a spike, or a single-phase plan, and worth the effort whenever
somebody other than the author has to trust the result later: a handover, an
audit, a post-incident review, due diligence.

## Filename

Sibling to the plan file, with a `-verify` suffix.

```
plan    .claude/plans/2026-08-24-oauth-login.md
verify  .claude/plans/2026-08-24-oauth-login-verify.md
```

## Three legs, not one

Each gate is proven on three legs. Any leg you cannot show is a leg that is not
proven, and the honest word for that is deferred, not done.

| Leg | Question it answers |
|-----|---------------------|
| **Trigger** | What fired the work, under realistic conditions? |
| **Effect** | What changed in the real system, as an artifact you can paste? |
| **Consumer** | Can whatever depends on it actually use the result? |

"The tests pass" covers part of the first leg inside the test suite. It says
nothing about the other two.

---

## Template

````markdown
# Verify Report: <plan title>

**Plan file**: `.claude/plans/<plan-filename>.md`
**Final commit(s)**: `<sha>`
**Verified date**: YYYY-MM-DD
**Grade at ship**: A | B | C
**Confidence at ship**: High | Medium | Low
**Verifier**: author | other agent | external reviewer

## Summary

One paragraph: what shipped, the key evidence, and anything left deferred.

## Phase-by-phase evidence

### Phase N: <name>

**Gate from the plan**: `<the gate text, quoted exactly, not paraphrased>`

**Status**: PASS | FAIL | PARTIAL | DEFERRED

**Trigger**
```
<the command, commit or event that fired Phase N>
```

**Effect**
```
<real output: a test result, a log slice, a file listing, a query result>
```

**Consumer**
```
<what downstream did with it, observed rather than assumed>
```

**Notes**: caveats, partial fulfilment, retries, and a reason code for anything DEFERRED.

## Completion Gate

For a plan carrying the Completion Gate CONDITIONAL section:

| Component | Status | Evidence |
|-----------|--------|----------|
| Registration | PASS | `<the check that shows the artifact is registered everywhere it must be>` |
| Connections | PASS | `<cross-reference or dependency check>` |
| Documentation | PASS | `<docs updated, links resolve>` |
| Orphans | PASS | `<orphan scan result>` |
| Consistency | PASS | `<version, count or term consistency check>` |

## Planned vehicle against actual

Records the vehicle the plan chose at Stage 0.5 against the one execution
actually used. This is what keeps the vehicle rubric falsifiable: without it,
a bad rule is never contradicted by anything.

| Phase | Planned vehicle | Planned routing | Actually used | Mismatch |
|-------|-----------------|--------------|---------------|----------|
| 1 | <vehicle> | <routing> | <observed> | none / over-vehicled / under-vehicled / mis-routed |

- **over-vehicled**: a heavy vehicle was chosen and barely used, for example a workflow where only one stage did real work.
- **under-vehicled**: a light vehicle was chosen and the work had to be fanned out by hand mid-task.
- **mis-routed**: a bulk or mechanical stage ran on the most expensive model, or the strongest model was used as a delegation target rather than an orchestrator.

If every phase reads `none`, say so explicitly. Anything else is input for the
next revision of the rubric.

## Verification method per domain

| Domain | Method | Evidence |
|--------|--------|----------|
| Software | test runner | `<output slice>` |
| AI / Agent | prompt smoke test on realistic input | `<output>` |
| Infrastructure | runbook walkthrough | `<runbook reference>` |
| Data | row counts plus sample inspection | `<query result>` |
| Content | rendered preview | `<URL or path>` |

## Open items

Every gap goes in this table. A gap described in prose is a gap that gets skipped.

| # | Item | Decision | Done? |
|---|------|----------|-------|
| 1 | <what is unproven, and which phase it belongs to> | **YES** - in scope, low risk, no blocker | **DONE** `<commit>` |
| 2 | <item> | **NO** - `<reason-code>`, <why this bucket> | Deferred until <date or condition> |
| 3 | <item> | **N/A** - <why this was never a real gap> | N/A |

Reason codes for a **NO**:

| Code | Meaning |
|------|---------|
| `time-dependent` | Needs observation over N days. Give the date it closes. |
| `external-blocker` | Waiting on a third party or an external system. |
| `destructive-no-backup` | Risky, with no rollback path. |
| `genuinely-needs-work` | Needs a design decision. Say which one. |
| `out-of-scope` | Scope was capped deliberately. Say by whom. |

Before writing **NO**, ask whether the item is doable now and low risk. If it is,
do it and write **YES**. If the plan shipped with nothing open, the table still
appears, with one row saying so.

## Sign-off

| Role | Name | Date | Evidence |
|------|------|------|----------|
| Implementer | <name> | YYYY-MM-DD | Commit `<sha>` |
| Reviewer | <name> | YYYY-MM-DD | <reference> |

A solo project keeps the implementer row and drops the reviewer row.
````

---

## What makes a good one

1. **Paste evidence, do not assert it.** "Tests pass" is a claim. The test runner output is evidence.
2. **Cover every phase.** A silently skipped phase reads exactly like a passing one.
3. **Keep the open items visible.** Burying a gap in prose is the failure this document exists to prevent.
4. **Stay reproducible.** A week later, every path and command in it should still resolve.
5. **Quote the gate exactly.** Paraphrasing a gate while declaring it passed is how a gate stops meaning anything.

## What does not belong in it

- Source code. Reference the artifact by path instead.
- Design rationale. That belongs in the plan or an ADR.
- Roadmap. That belongs in the plan's Post-Completion section.
- Anything subjective. "Looks good" is not a verification method.

## Lifecycle

| Stage | Action |
|-------|--------|
| Create | At the plan's final shipped commit. |
| Update | If a deferred leg is later closed, append an update section with the new evidence rather than editing history. |
| Keep | Beside the plan, indefinitely. It records what was actually known at ship time. |

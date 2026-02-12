# Universal Planning Framework

**Source:** Evolved from analysis of 117 plans + 195 handoffs in the Evolving system
**Category:** planning, validation, meta-cognition
**Tags:** planning, framework, universal, discovery, sparring, quality

---

## Problem

Critical insights are consistently found AFTER initial planning - during interviews, execution, or post-mortem. What's missing from plans IS what gets discovered painfully during execution.

## Three-Stage Framework

### Stage 0: Before Plan (Discovery & Sparring)

Runs BEFORE writing a single line of the plan. Not a rigid checklist - a thinking toolkit.

**Intelligence rule:** The agent decides which checks to run based on context. Skipping a check is fine IF the agent can articulate WHY. Running all 10 on a trivial task wastes time. Running zero on a complex task creates blind spots.

**Priority tiers:**

| Tier | Checks | When |
|------|--------|------|
| Always consider | 0.1 Existing Work, 0.7 Feasibility, 0.9 Better Alternatives | Every non-trivial plan |
| Usually relevant | 0.2 Factual Verification, 0.3 Official Docs, 0.8 ROI | Most plans |
| Context-dependent | 0.4 Updates Scan, 0.5 Best Practices, 0.6 Deep Research, 0.10 Competitive | When domain signals it |

1. **Existing Work Audit**: What already exists? Files, code, docs, prior art? *(Skip: greenfield with no prior work)*
2. **Factual Verification**: Are the user's claims/assumptions correct? *(Skip: user provided evidence)*
3. **Official Docs Check**: Authoritative sources consulted? API docs, legal reqs? *(Skip: no official standards exist)*
4. **Online Updates Scan**: Has anything changed? New versions, deprecated features? *(Skip: user confirmed latest info)*
5. **Best Practices Research**: What do experts recommend? *(Skip: user is domain expert)*
6. **Deep Research Decision**: Should we do thorough web research BEFORE planning? *(Skip: low uncertainty AND low stakes)*
7. **Sparring: Feasibility**: Is this even possible as described? *(Skip: proven approach, done before)*
8. **Sparring: ROI**: Is this worth doing? Cost vs. benefit? *(Skip: user validated ROI or must-do)*
9. **Sparring: Better Alternatives (AHA Effect)**: Is there a fundamentally better approach? *(Skip: user compared alternatives)*
10. **Competitive Landscape**: Who else solved this? What can we learn? *(Skip: internal project, no public equivalent)*

**The AHA Effect (Check 0.9) - single most valuable check:**
- User wants custom CMS → "Considered Strapi/Payload? 90% of what you need, 10% effort"
- User wants 50 blog posts → "5 deep pillar posts + derivatives might outperform 50 shallow ones"
- User wants to build from scratch → "This open-source project does 80%, fork and customize"
- User wants to hire 3 devs → "No-code MVP with Cursor + Claude could validate in 2 days"

**Skip Stage 0 when:**
- Plan is < 3 phases AND < 2h effort
- User explicitly says "quick plan", "skip discovery", or "just plan"

**Continuation mode:** When resuming an existing plan, Stage 0 narrows to: "What changed since last session?" - not full discovery.

**User override:** If user says "skip Stage 0" - respect it. Framework is a tool, not a gate.

---

### Stage 1: The Plan

**5 CORE Sections (always required):**

1. **Context & Why** - Why this exists, what problem it solves. Max 3 sentences. NOT "improve X" but WHY improve X.
2. **Success Criteria** - Measurable outcomes, not activities. Includes NOT-scope and FAILED conditions (kill criteria + timeout). Red flag: if you can't write a FAILED condition, criteria are too vague.
3. **Assumptions & Validation** - What we're betting on being true. Format: `[assumption] → VALIDATE BY: [method] → IMPACT IF WRONG: [consequence]`. Stage 0 = approach-level, this = implementation-level. Red flag: empty section means not thinking hard enough.
4. **Phases** - Ordered stages with effort estimates (max 3-4h each), dependencies, and binary gates. Gate rules: PASS or FAIL only. Must be verifiable. If gate fails → STOP, fix or replan. Bad gate: "Code is written." Good gate: "3 endpoints return valid JSON under test suite."
5. **Verification** - How to prove it worked. Always split: Automated (tests, CI, monitoring) + Manual (walkthroughs, reviews). If Automated empty → "Why can't this be tested?" If Manual empty → "User-facing aspect ignored?"

**14 CONDITIONAL Sections (add when relevant):**

- **Rollback / Undo Strategy** - Trigger, steps, data recovery, duration, point of no return. *(Activate: changes hard to reverse)*
- **Risk Assessment** - Likelihood, impact, mitigation, detection trigger per risk. *(Activate: high stakes or complexity >= 5 phases)*
- **Post-Completion Plan** - Monitor what/how long, maintain schedule, if-fails plan. *(Activate: needs ongoing attention after "done")*
- **Budget & Resources** - Costs, ceiling, decision point for re-evaluation. *(Activate: money, time, or materials matter)*
- **User/Customer Validation** - Who, when, method, minimum signal for pass. *(Activate: end users involved)*
- **Legal & Compliance** - Which regulations, requirements, verification method. *(Activate: regulations apply)*
- **Security & Privacy** - Sensitive data, threats, controls, audit method. *(Activate: sensitive data or access involved)*
- **Resume Protocol** - TL;DR (update each session), context load order, last completed, next action, blockers. *(Activate: >10h effort, multi-session)*
- **Incremental Delivery** - MVP definition, "good enough" threshold, natural stopping points. *(Activate: >5 phases or >20h effort)*
- **Delegation & Team Strategy** - Who/what per phase, interface contracts, verification of delegated output. *(Activate: work can be parallelized)*
- **Dependencies & Blockers** - Type, status, fallback, lead time per dependency. *(Activate: external dependencies exist)*
- **Related Work & Integration** - Project, relationship type, coordination needs. *(Activate: connects to other projects)*
- **Timeline & Deadlines** - Duration per phase with 20%+ buffer, hard deadline + consequence. *(Activate: hard deadlines exist)*
- **Stakeholder Communication** - Who needs what info, when, how. *(Activate: other people need to know)*

---

### Stage 2: Meta (4 Checks)

After creating the plan, run:

1. **Delegation Strategy** - Which parts to sub-agents/teams? What model/agent type per phase?
2. **Research Needs** - Which phases need web research during execution? Mark them now.
3. **Review Gates** - After which phases stop and validate? Confirm gates are in place.
4. **Anti-Pattern Check** - Quick scan against 12 anti-patterns below. Fix any found.

---

## Replanning Triggers

Return to Stage 0 (narrowed) when:
- Gate fails and fix changes scope
- Core assumption proves wrong (IMPACT IF WRONG activates)
- Timeline slips beyond buffer
- New dependency or blocker emerges
- Success criteria change due to external factors
- User pivots direction

**Replanning ≠ starting over.** Update what changed → re-evaluate remaining phases → continue.

---

## Domain Detection

Automatically include relevant CONDITIONAL sections based on domain:

**Software Development:**
- Dependencies, Risks, Rollback, Testing (via Verification), Monitoring (via Post-Completion)

**Multi-Agent / AI System:**
- Dependencies, Risks, Testing, Monitoring, Delegation, Security

**Business / Strategy:**
- Timeline, Budget & Resources, Communication, User Validation

**Content / Marketing:**
- Timeline, User Validation, Legal & Compliance

**Infrastructure / DevOps:**
- Dependencies, Risks, Rollback, Monitoring, Resume Protocol

**Multi-Domain (2+ above):**
- Union of all relevant sections from matched domains

---

## 12 Anti-Patterns

| # | Anti-Pattern | Detection Rule | Fix |
|---|-------------|---------------|-----|
| 1 | **Unvalidated Assumptions** | Entries without VALIDATE BY method | Add validation + IMPACT IF WRONG |
| 2 | **All-or-Nothing Phases** | Any phase >4h | Split into 3-4h sub-phases |
| 3 | **Vague Success** | "improve", "better", "enhance" without metrics | Add specific numbers and thresholds |
| 4 | **No Rollback** | Irreversible changes without Rollback section | Add Rollback or confirm reversible |
| 5 | **Plan Ends at Deploy** | Last phase is Deploy/Publish/Submit | Add Post-Completion: monitoring, if-fails |
| 6 | **No Resume Protocol** | >10h effort without Resume section | Add TL;DR, context load order, next action |
| 7 | **Parallel Without Contracts** | Delegation without interface definitions | Define what each stream produces, in what format |
| 8 | **Blind Delegation Trust** | No verification after delegation | Spot-check, cross-reference, count deliverables |
| 9 | **Skipping Stage 0** | Plan starts at Phase 1 without discovery | Most expensive plans skip discovery |
| 10 | **First Idea = Final** | No alternatives considered | Run Check 0.9: better approach exists? |
| 11 | **Zombie Project** | No FAILED conditions, no timeout | Add kill criteria + timeout to Success Criteria |
| 12 | **Timeline Fantasy** | Zero buffer or round-number estimates | Add 20%+ buffer, break into smaller chunks |

---

## Quality Rubric

| Grade | Criteria |
|-------|----------|
| C (Viable) | All 5 CORE + at least 1 CONDITIONAL. No critical anti-patterns (#3, #9, #11). |
| B (Solid) | C + Stage 0 done + FAILED conditions + delegation strategy. Zero anti-patterns. |
| A (Excellent) | B + sparring (0.7-0.9) + alternatives considered + gates on all phases + resume protocol (if multi-session). Replanning triggers defined. |
| Red Flags | Vague criteria, no Stage 0, assumptions untested, >6 phases without MVP, first idea unchallenged. Fix before implementation. |

---

## When to Activate

**ALWAYS use for:**
- New features, products, system components
- Architecture changes touching 3+ files
- Multi-phase projects (3+ phases or >2h)
- Anything with external dependencies

**SKIP when ALL true:**
- Single file affected
- No external dependencies
- < 50 lines changed
- No data migration or schema change
- No user-facing behavior change
- Rollback = git revert

---

## Quick Reference

```
STAGE 0 (Before):
  Always:  0.1 Existing Work | 0.7 Feasibility | 0.9 AHA Effect
  Usually: 0.2 Facts | 0.3 Docs | 0.8 ROI
  Maybe:   0.4 Updates | 0.5 Practices | 0.6 Research | 0.10 Competitive
  Skip:    <3 phases AND <2h | user says skip | continuation → "what changed?"

STAGE 1 (Plan):
  CORE:  Context | Success (FAILED) | Assumptions (IMPACT) | Phases (Gates) | Verification (Auto+Manual)
  COND:  Rollback | Risk | Post-Completion | Budget | User Validation | Legal |
         Security | Resume | Incremental | Delegation | Dependencies |
         Related Work | Timeline | Stakeholders

STAGE 2 (Meta):
  M.1 Delegation | M.2 Research Needs | M.3 Review Gates | M.4 Anti-Patterns

REPLAN: Gate fails | Assumption wrong | Buffer exceeded | New blocker | User pivots
```
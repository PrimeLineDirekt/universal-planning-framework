# Universal Planning Framework

**Source:** Evolved from analysis of 117 plans + 195 handoffs in the Evolving system
**Version:** 1.1
**Category:** planning, validation, meta-cognition
**Tags:** planning, framework, universal, discovery, sparring, quality

---

## Problem

Critical insights are consistently found AFTER initial planning - during interviews, execution, or post-mortem. What's missing from plans IS what gets discovered painfully during execution.

## Three-Stage Framework

### Stage 0: Before Plan (Discovery & Sparring)

Runs BEFORE writing a single line of the plan. Not a rigid checklist - a thinking toolkit.

**Intelligence rule:** The agent decides which checks to run based on context. Skipping a check is fine IF the agent can articulate WHY. Running all 12 on a trivial task wastes time. Running zero on a complex task creates blind spots.

**Priority tiers:**

| Tier | Checks | When |
|------|--------|------|
| Always consider | 0.1 Existing Work, 0.7 Feasibility, 0.9 Better Alternatives | Every non-trivial plan |
| Always (coding domains) | 0.3 Official Docs | Software, Data, Infrastructure plans |
| Usually relevant | 0.2 Factual Verification, 0.3 Official Docs, 0.8 ROI | Most plans |
| Context-dependent | 0.4 Updates Scan, 0.5 Best Practices, 0.6 Deep Research, 0.10 Competitive, 0.11 Constraints, 0.12 People Risk | When domain signals it |

1. **Existing Work Audit**: What already exists? Files, code, docs, prior art? *(Skip: greenfield with no prior work)*
2. **Factual Verification**: Are the user's claims/assumptions correct? For AI-generated plans, explicitly note which facts were verified vs. agent knowledge. *(Skip: user provided evidence)*
3. **Official Docs Check**: Authoritative sources consulted? API docs, legal reqs? **Always for coding domains.** *(Skip: no official standards exist AND not a coding domain)*
4. **Online Updates Scan**: Has anything changed? New versions, deprecated features? *(Skip: user confirmed latest info)*
5. **Best Practices Research**: What do experts recommend? *(Skip: user is domain expert)*
6. **Deep Research Decision**: Should we do thorough web research BEFORE planning? *(Skip: low uncertainty AND low stakes)*
7. **Sparring: Feasibility**: Is this even possible as described? *(Skip: proven approach, done before)*
8. **Sparring: ROI**: Is this worth doing? Cost vs. benefit? *(Skip: user validated ROI or must-do)*
9. **Sparring: Better Alternatives (AHA Effect)**: Is there a fundamentally better approach? *(Skip: user compared alternatives)*
10. **Competitive Landscape**: Who else solved this? What can we learn? *(Skip: internal project, no public equivalent)*
11. **Constraint Discovery**: What are you NOT allowed to do? Budget ceilings, tech mandates, regulatory limits, non-negotiable deadlines, architectural constraints. *(Skip: no external constraints AND fully greenfield)*
12. **People Risk**: Who can veto/block this? Approval chains, key person dependencies, review queues with lead times. *(Skip: solo project with no approvals needed)*

**The AHA Effect (Check 0.9) - single most valuable check:**
- User wants custom CMS - "Considered Strapi/Payload? 90% of what you need, 10% effort"
- User wants 50 blog posts - "5 deep pillar posts + derivatives might outperform 50 shallow ones"
- User wants to build from scratch - "This open-source project does 80%, fork and customize"
- User wants to hire 3 devs - "No-code MVP with Cursor + Claude could validate in 2 days"

**Skip Stage 0 when:**
- Plan is < 3 phases AND < 2h effort AND changes are fully reversible
- User explicitly says "quick plan", "skip discovery", or "just plan"

**Continuation mode:** When resuming an existing plan, Stage 0 narrows to: "What changed since last session?" - not full discovery.

**User override:** If user says "skip Stage 0" - respect it. Framework is a tool, not a gate.

---

### Stage 1: The Plan

**End State (recommended):** Before diving into sections, describe in 1 paragraph what concretely exists after this plan succeeds. Not metrics (that's Success Criteria), not tasks (that's Phases) - the outcome painted for the reader. Context & Why explains the problem. End State describes the solution. Success Criteria measures both.

**5 CORE Sections (always required):**

1. **Context & Why** - Why this exists, what problem it solves. Max 3 sentences. NOT "improve X" but WHY improve X.
2. **Success Criteria** - Measurable outcomes, not activities. Includes NOT-scope and FAILED conditions (kill criteria + timeout). Red flag: if you can't write a FAILED condition, criteria are too vague.
3. **Assumptions & Validation** - What we're betting on being true. Format: `[assumption] -> VALIDATE BY: [method] -> IMPACT IF WRONG: [consequence]`. Stage 0 = approach-level, this = implementation-level. Red flag: empty section means not thinking hard enough.
4. **Phases** - Ordered stages with dependencies and binary gates. Gate rules: PASS or FAIL only. Must be verifiable. If gate fails - STOP, fix or replan. Bad gate: "Code is written." Good gate: "3 endpoints return valid JSON under test suite."
5. **Verification** - How to prove it worked. Split into three sub-sections:
   - **Automated** (point-in-time): Tests, CI, linters - proves "it works at ship time"
   - **Manual** (point-in-time): Reviews, walkthroughs, demos - catches what automated can't
   - **Ongoing Observability**: Production metrics, alerts, health checks - proves "it keeps working"
   - If Automated empty - "Why can't this be tested?" If Manual empty - "User-facing aspect ignored?"

**Phase sizing:**
- **Coding domains** (Software, AI, Data, Infrastructure): Size by scope (files touched, features delivered, tests passing), not hours. Hours create false precision when AI executes the plan.
- **Non-coding domains** (Business, Content, Research): Time estimates remain useful as rough guides, explicitly marked as estimates not commitments.

**Phase template (coding domains):**
```
Phase N: [Name]
Scope: [files/features/components affected]
Deliverable: [what exists after this phase]
Gate: [binary, observable check]
Review: [what gets reviewed] [by whom/what] [pass criteria]
```

**Review Checkpoints:** Every 2 phases of implementation, a review checkpoint is mandatory. For security-sensitive work, every phase. Review checkpoints are binary gates: "Code review confirms no critical issues" or "Cross-reference check: new code follows existing patterns."

**18 CONDITIONAL Sections (add when relevant):**

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
- **Reference Library** - Official docs, best practices, standards consulted. Format: `[source] | [version/date] | [what it informed] | [link]`. **Mandatory for Software, Data, Infrastructure domains when plan has 3+ phases.** Should be embedded/linked in final deliverable. *(Activate: coding domains, or any plan consulting external sources)*
- **Learning & Knowledge Capture** - What was learned, where captured, when, for whom. *(Activate: research, multi-session, AI agent plans, new technology)*
- **Feedback Architecture** - What feedback collected, how routed back, decision threshold. *(Activate: iterative work, user-facing features, content series)*
- **Completion Gate** - Before declaring a plan DONE, verify: (1) Registration - all artifacts registered where they belong, (2) Connections - cross-references and relationships established, (3) Documentation - README, CHANGELOG, indexes updated, (4) Orphan Detection - no unreferenced files or partial work, (5) Consistency - versions, counts, terms consistent across all files. Each project defines its own registration points. *(Activate: multi-file changes, system integration work, plans producing artifacts that must be registered somewhere. Skip: single-file changes, purely internal work)*

---

### Stage 1.5: Autonomous Hardening (Optional)

Stress-test the plan from 6 adversarial perspectives without human input. Purpose: catch gaps that the plan author is blind to.

**6 Perspectives (in order):**

1. **Outside Observer** - "Can I summarize the goal in 15 words? Are success metrics unambiguous? Is there an End State I can picture? Are abbreviations defined?"
2. **Pessimistic Risk Assessor** - "What single thing kills this? If Phase 3 fails, can we recover? Do FAILED conditions have timeouts? Is timeline realistic with buffer?"
3. **Pedantic Lawyer** - "Does any gate contain 'looks good', 'complete', 'done'? For each delegation, is there a defined deliverable format? Does the plan end at deploy?"
4. **Skeptical Implementer** - "What's the first blocker at 9am tomorrow? Which assumption has no evidence? Which gate requires input not in dependencies? Are there unverified facts?"
5. **The Manager** - ">10h effort without Resume Protocol? Is complexity realistic? Is NOT-scope explicit? Are hard deadlines acknowledged?"
6. **Devil's Advocate** - "Was Stage 0 AHA check actually done? What if the core assumption is wrong? Is there an 80/20 simpler path? What makes this obsolete?"

**Mutation rules:**
- **Can fix in place**: Vague gate text, missing FAILED conditions, missing VALIDATE BY, missing CONDITIONAL sections, unclear phase scope, unverified facts
- **Cannot mutate**: Phases (add/remove/reorder), strategic direction, NOT-scope decisions, Stage 0 discoveries, user's explicit choices
- **Must note for user** (as `[Stage 1.5 Note:]`): Alternative approaches found, strategic concerns, scope expansion suggestions

**Output:** Hardened plan + Hardening Log section appended (perspective, finding, action taken).

**Discovery Consolidation:** Hardening must verify all Stage 0 findings are addressed in the plan or explicitly dismissed with reason (anti-pattern #20).

**Skip when:** <3 phases, user says skip, plan already has Hardening Log (idempotency).

---

### Stage 2: Meta (7 Checks)

After creating the plan, run:

1. **Delegation Strategy** - Which parts to sub-agents/teams? What model/agent type per phase?
2. **Research Needs** - Which phases need web research during execution? Mark them now.
3. **Review Gates** - After which phases stop and validate? Confirm gates are in place.
4. **Anti-Pattern Check** - Quick scan against 21 anti-patterns below. Fix any found.
5. **Cold Start Test** - Can a fresh agent execute this cold? Plan is self-contained, no oral history needed.
6. **Plan Hygiene Protocol** - After each phase during execution: mark gate result, scope changes, assumption updates.
7. **Discovery Consolidation Check** - Verify every Stage 0 finding is addressed or dismissed in the final plan.

**Inline Anti-Pattern Alerts (catch during Stage 1 writing):** Vague success (#3), no FAILED conditions (#11), oversized phases (#2), assumed facts (#21).

---

## Plan Confidence Level

Assign at plan header alongside Quality Grade:

- **High**: All assumptions validated, proven approach, no external unknowns
- **Medium**: 1-2 unvalidated assumptions, manageable risk (default)
- **Low**: Core assumption unvalidated, first-time approach

**Affects execution:** Low confidence = Phase 1 must be a validation sprint. No delegation of critical path until confidence rises.

---

## Replanning Protocol

When a replanning trigger fires, follow these 6 steps:

1. **Triage** - Classify trigger type: gate failure, assumption wrong, scope change, external blocker, user pivot
2. **Scope damage** - Which phases affected? Cascading impact? Can remaining phases continue?
3. **Update in place** - Preserve history with `[REPLANNED: reason]` markers. Never overwrite original content.
4. **Recheck anti-patterns** - Run anti-pattern scan on modified sections only
5. **Re-confirm confidence level** - Almost always drops after replanning
6. **Resume** - Start from first unstarted phase

**Replanning triggers:**
- Gate fails and fix changes scope
- Core assumption proves wrong (IMPACT IF WRONG activates)
- Timeline slips beyond buffer
- New dependency or blocker emerges
- Success criteria change due to external factors
- User pivots direction

**Replanning is not starting over.** Update what changed, re-evaluate remaining phases, continue.

---

## Domain Detection

Automatically include relevant CONDITIONAL sections based on domain (8 domains):

**Software Development:**
- Dependencies, Risks, Rollback, Post-Completion, Delegation, Reference Library
- Completion Gate: exports/imports valid, tests cover new code, API docs updated, package/module registered in project index
- Review Checkpoints: every 2 phases. Scope-based phases.

**Multi-Agent / AI System:**
- Dependencies, Risks, Delegation, Security, Post-Completion, Reference Library
- Completion Gate: agent configs registered, prompts versioned, model settings documented, tool registrations complete
- Review Checkpoints: every 2 phases. Scope-based phases.

**Business / Strategy:**
- Timeline, Budget & Resources, Communication, User Validation
- Completion Gate: stakeholder notifications sent, process docs updated, handoff complete, SOPs revised
- Review Checkpoints: per milestone. Time-based phases OK.

**Content / Marketing:**
- Timeline, User Validation, Legal & Compliance, Feedback Architecture
- Completion Gate: all channels published, content indexes updated, metadata set, cross-links working
- Review Checkpoints: per draft. Time-based phases OK.

**Infrastructure / DevOps:**
- Dependencies, Risks, Rollback, Post-Completion, Resume Protocol, Reference Library
- Completion Gate: monitoring configured, runbooks updated, config files registered, access documented
- Review Checkpoints: every phase. Mixed phase sizing.

**Data & Analytics:**
- Dependencies, Risks, Post-Completion, Rollback, Legal, Security, Reference Library
- Completion Gate: data contracts updated, pipeline registered, catalog entries created, schema docs current
- Unique: data contracts, baseline+comparison success criteria, data quality gates.
- Review Checkpoints: every phase. Mixed phase sizing.

**Research / Exploration:**
- Incremental Delivery, Budget, Related Work, Post-Completion, Risk, Learning & Knowledge Capture
- Completion Gate: findings captured, knowledge base updated, decision documented, method reproducible
- Unique: success = decision not deliverable, null result is valid, time-based FAILED conditions.
- Review Checkpoints: per finding. Time-based phases OK.

**Multi-Domain (2+ above):**
- Union of all relevant sections from matched domains
- Completion Gate: union of all relevant domain checks verified
- Review Checkpoints: use the most conservative interval from matched domains

---

## 21 Anti-Patterns

### Core (1-12)

| # | Anti-Pattern | Detection Rule | Fix |
|---|-------------|---------------|-----|
| 1 | **Unvalidated Assumptions** | Entries without VALIDATE BY method | Add validation + IMPACT IF WRONG |
| 2 | **All-or-Nothing Phases** | Unclear scope boundaries or no testable intermediate checkpoint | Split into phases with clear scope and observable gates |
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

### AI-Specific (13-17)

| # | Anti-Pattern | Detection Rule | Fix |
|---|-------------|---------------|-----|
| 13 | **Confidence Without Evidence** | Assertions without validation source | Add data source or move to Assumptions |
| 14 | **Wrong Level of Detail** | Over-detailed in wrong places, vague in critical ones | Redistribute detail to where it matters |
| 15 | **Premature Precision** | Numbers without citation/baseline | Add source for each number |
| 16 | **Hallucinated Effort Estimate** | AI work estimated without iteration cycles | Add review/iteration multiplier |
| 17 | **Delegation Without Context Transfer** | Agents named but input not specified | Add context handoff spec per delegation |

### Quality (18-21)

| # | Anti-Pattern | Detection Rule | Fix |
|---|-------------|---------------|-----|
| 18 | **Unverifiable Gates** | Quality-judgment words in gates ("good", "acceptable") | Replace with objective, observable criteria |
| 19 | **Missing Tool Fallback** | Assumes tool availability without fallback | Add "If X unavailable - Y" |
| 20 | **Discovery Amnesia** | Final plan references fewer findings than Stage 0 produced | Stage 2 consolidation check: every finding addressed or dismissed |
| 21 | **Assumed Facts** | Statements assert facts without source | Cite source or move to Assumptions with VALIDATE BY |

---

## Quality Rubric

| Grade | Criteria |
|-------|----------|
| C (Viable) | All 5 CORE + at least 1 CONDITIONAL. No critical anti-patterns (#3, #9, #11, #20, #21). |
| B (Solid) | C + Stage 0 done + FAILED conditions + Confidence Level + Constraint Discovery (0.11) + Cold Start Test passed. Zero anti-patterns across all 21. |
| A (Excellent) | B + sparring (0.7-0.9) + People Risk (0.12) + Review Checkpoints in phases + Reference Library (coding domains) + Learning & Knowledge Capture (multi-session). Replanning triggers defined. |
| Red Flags | Vague criteria, no Stage 0, assumptions untested, >6 phases without MVP, first idea unchallenged, numbers without sources, FAILED conditions not measurable, delegated work without input/output specs. Fix before implementation. |

**Semantic quality checks:** Numbers have sources, FAILED conditions are measurable, gates reference observable outputs, delegated work has input/output specs.

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
STAGE 0 (Before) - 12 Checks:
  Always:  0.1 Existing Work | 0.7 Feasibility | 0.9 AHA Effect
  Always (coding): + 0.3 Official Docs
  Usually: 0.2 Facts | 0.3 Docs | 0.8 ROI
  Maybe:   0.4 Updates | 0.5 Practices | 0.6 Research | 0.10 Competitive
           0.11 Constraints | 0.12 People Risk
  Skip:    <3 phases AND <2h AND reversible | user says skip | continuation -> "what changed?"

STAGE 1 (Plan):
  End State: 1 paragraph, concrete outcome
  CORE:  Context | Success (FAILED) | Assumptions (IMPACT) | Phases (Gates + Review) |
         Verification (Auto + Manual + Observability)
  COND:  Rollback | Risk | Post-Completion | Budget | User Validation | Legal |
         Security | Resume | Incremental | Delegation | Dependencies |
         Related Work | Timeline | Stakeholders | Reference Library | Learning |
         Feedback | Completion Gate
  Phases: Scope-based (coding) or time-based (non-coding). Review checkpoint every 2 phases.
  Confidence: High / Medium / Low

STAGE 1.5 (Hardening, Optional):
  6 Perspectives: Observer | Pessimist | Lawyer | Implementer | Manager | Devil's Advocate
  Fix in place: vague gates, missing FAILED, missing sections
  Note for user: strategic concerns, alternatives, scope changes
  Output: Hardened plan + Hardening Log

STAGE 2 (Meta) - 7 Checks:
  M.1 Delegation | M.2 Research | M.3 Review Gates | M.4 Anti-Patterns (21)
  M.5 Cold Start Test | M.6 Plan Hygiene | M.7 Discovery Consolidation

REPLAN (6 steps): Triage | Scope damage | Update in place | Recheck | Re-confirm confidence | Resume
ANTI-PATTERNS: 12 Core + 5 AI + 4 Quality = 21 total
DOMAINS: Software | AI/Agent | Business | Content | Infrastructure | Data | Research | Multi-Domain
```

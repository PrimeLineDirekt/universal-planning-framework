---
description: Check plan quality against Universal Planning Framework v3 standards
argument-hint: [plan-file-path]
model: sonnet
---

# Plan Quality Check Command

Read the plan file at `$ARGUMENTS` and evaluate it against the Universal Planning Framework v3 quality standards.

## Check Process

### 1. CORE Sections Check (Required)

Verify all 5 CORE sections are present, complete, and v3-compliant:

**Context & Why:**
- Is the "why" clear in max 3 sentences?
- Does it explain what triggered this NOW, not just what it does?
- Would someone unfamiliar understand the goal in 60 seconds?

**Success Criteria:**
- Are outcomes measurable and specific (not "improve" or "better")?
- Is NOT-scope explicitly defined?
- Are FAILED conditions present (kill criteria + timeout)?
- Red flag: If no FAILED condition exists, criteria are too vague.

**Assumptions & Validation:**
- Does every assumption have the triple format: `[assumption] → VALIDATE BY: [method] → IMPACT IF WRONG: [consequence]`?
- Are there at least 2 assumptions? (Empty = not thinking hard enough)
- Is there a distinction between approach-level (Stage 0) and implementation-level assumptions?

**Phases:**
- Does every phase have: name, effort estimate (max 3-4h each), deliverable, dependencies, and a binary gate?
- Are gates verifiable (test passes, metric met, demo works)  - not "code complete" or "looks good"?
- Is it clear that a failed gate means STOP?

**Verification:**
- Is it split into Automated + Manual?
- If Automated is empty: is there a reason why it can't be tested automatically?
- If Manual is empty: is there a user-facing aspect being ignored?

### 2. Domain Detection

Analyze the plan to determine domain(s):

- **Software Development**  - APIs, code, systems, databases
- **Multi-Agent / AI System**  - agents, orchestration, LLM pipelines, prompts
- **Business / Strategy**  - process, growth, market, revenue
- **Content / Marketing**  - campaigns, content, audience, SEO
- **Construction / Operations**  - physical infrastructure, logistics
- **Multi-Domain**  - if 2+ domains apply, use union of all relevant sections

### 3. CONDITIONAL Sections Check

Based on detected domain, verify relevant sections are present:

**Software Development:**
- Dependencies & Blockers, Risk Assessment, Rollback, Post-Completion Plan (monitoring), Delegation

**Multi-Agent / AI System:**
- Dependencies & Blockers, Risk Assessment, Delegation & Team Strategy, Security & Privacy, Post-Completion Plan

**Business / Strategy:**
- Timeline & Deadlines, Budget & Resources, Stakeholder Communication, User/Customer Validation

**Content / Marketing:**
- Timeline & Deadlines, User/Customer Validation, Legal & Compliance

**Construction / Operations:**
- Dependencies & Blockers, Risk Assessment, Timeline & Deadlines, Budget & Resources

**Multi-Domain:**
- Union of all sections from matched domains

**For any plan >10h effort:**
- Resume Protocol (TL;DR, context load order, next action)

**For any plan >5 phases or >20h effort:**
- Incremental Delivery (MVP, "good enough" threshold, stopping points)

### 4. Anti-Pattern Scan

Check for these 12 anti-patterns. Each has a specific detection rule:

| # | Anti-Pattern | How to Detect |
|---|-------------|---------------|
| 1 | **Unvalidated Assumptions** | Assumption entries without VALIDATE BY method |
| 2 | **All-or-Nothing Phases** | Any phase estimated at >4h |
| 3 | **Vague Success** | Success criteria contain "improve", "better", "enhance" without metrics |
| 4 | **No Rollback** | Irreversible changes with no Rollback section |
| 5 | **Plan Ends at Deploy** | Last phase is Deploy/Publish/Submit with nothing after |
| 6 | **No Resume Protocol** | >10h effort without Resume Protocol section |
| 7 | **Parallel Without Contracts** | Delegation section without interface definitions |
| 8 | **Blind Delegation Trust** | Delegation without verification step for output |
| 9 | **Skipping Stage 0** | Plan starts at Phase 1 without any discovery evidence |
| 10 | **First Idea = Final** | No evidence alternatives were considered (AHA Effect) |
| 11 | **Zombie Project** | No FAILED conditions, no timeout, no kill criteria |
| 12 | **Timeline Fantasy** | Zero buffer or all estimates are suspiciously round numbers |

### 5. Stage 0 Evidence Check

Was discovery done before planning? Look for signs:

- References to existing work audit (check 0.1)
- Evidence that feasibility was questioned (check 0.7)
- Evidence that alternatives were considered (check 0.9  - AHA Effect)
- If no Stage 0 evidence: flag anti-pattern #9

### 6. Quality Scoring

**Grade C (Viable):**
- All 5 CORE sections present
- At least 1 relevant CONDITIONAL section
- No critical anti-patterns (#3, #9, #11)

**Grade B (Solid):**
- All 5 CORE sections with v3 formats (FAILED conditions, triple-format assumptions, binary gates, split verification)
- 3+ relevant CONDITIONAL sections for detected domain
- Zero anti-patterns
- Delegation strategy defined
- Stage 0 evidence present

**Grade A (Excellent):**
- All CORE sections with measurable specifics in v3 format
- All relevant CONDITIONAL sections for detected domain(s)
- Sparring completed (checks 0.7-0.9) with evidence
- Binary gates on every phase
- Resume protocol present (if multi-session)
- Replanning triggers defined
- Proactive risk mitigation with detection triggers

**Red Flags (must fix before ANY implementation):**
- Missing or vague Success Criteria
- No FAILED conditions (kill criteria)
- Empty Assumptions section
- No verification method
- Phases without gates
- No risks identified
- Timeline with zero buffer

---

## Report Format

```markdown
# Plan Quality Report

**Plan:** [filename]
**Domain:** [detected domain(s)]
**Grade:** [C / B / A]
**Recommendation:** [Proceed / Fix gaps then proceed / Replan from Stage 0]

---

## CORE Sections

| Section | Status | v3 Compliant? | Issue |
|---------|--------|---------------|-------|
| Context & Why | ✅/⚠️/❌ | Yes/No | [specific issue or " -"] |
| Success Criteria | ✅/⚠️/❌ | Yes/No | [FAILED conditions present?] |
| Assumptions | ✅/⚠️/❌ | Yes/No | [Triple format used?] |
| Phases | ✅/⚠️/❌ | Yes/No | [Binary gates present?] |
| Verification | ✅/⚠️/❌ | Yes/No | [Auto + Manual split?] |

## CONDITIONAL Sections

Based on [domain] domain:

| Section | Status | Notes |
|---------|--------|-------|
| [relevant section] | ✅/❌/N/A | [notes] |
| ... | ... | ... |

## Stage 0 Evidence

- Existing work checked: [yes/no/unclear]
- Feasibility questioned: [yes/no/unclear]
- Alternatives considered: [yes/no/unclear]
- Overall: [Stage 0 done / Partially done / Skipped]

## Anti-Patterns Found

[For each found:]
- **#[N] [Name]**: [specific example from the plan]
  → Fix: [concrete action to resolve]

[Or:]
No anti-patterns detected.

## Red Flags

[For each found:]
- 🚩 [Description]: [why this blocks implementation]

[Or:]
No red flags detected.

## Improvement Suggestions

[Ordered by impact, max 5:]

1. [Highest impact suggestion with specific action]
2. [Next suggestion]
3. [Next suggestion]

## Summary

[2-3 sentences: current grade, what's strong, what needs work, recommended action]
```

---

## Replanning Recommendation

If the quality check reveals:
- 3+ Red Flags
- Grade below C
- Multiple CORE sections missing or fundamentally incomplete
- Stage 0 completely skipped on a complex plan

→ Recommend `/interview-plan` first, or returning to Stage 0 entirely. Don't implement a broken plan.

---

## Examples

**Good Success Criteria:**
```
SUCCESS when:
- API p95 latency < 200ms for 10K concurrent users
- Customer churn drops from 8% to 5% within Q2

FAILED when:
- Memory exceeds 2GB under normal load → kill and redesign
- Not shipped within 2 weeks → re-evaluate scope
```

**Bad Success Criteria:**
- "Make the app faster" (not measurable)
- "Improve user experience" (no metric)
- No FAILED conditions at all (zombie project)

**Good Assumptions:**
```
- Database handles 5x load without schema changes
  → VALIDATE BY: Load test in staging
  → IMPACT IF WRONG: Need migration phase, +1 week
```

**Bad Assumptions:**
- (Empty section)
- "This will work" (no validation method)
- "Users will like it" (no impact analysis)

**Good Gate:**
```
Gate: User can complete checkout flow E2E in staging  - automated test passes
```

**Bad Gate:**
```
Gate: "Code is written" (not verified, not binary)
```

---

## Usage

```bash
/plan-quality-check path/to/plan.md
```

Provides objective assessment against Universal Planning Framework v3 standards. Use before implementation to catch planning gaps early. For deeper exploration, use `/interview-plan` for interactive sparring.